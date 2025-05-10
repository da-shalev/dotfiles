{ inputs, withSystem, ... }: {
  _module.args = {
    linuxGenesis = architecture: hostName: systemModules:
      let
        specialArgs = withSystem architecture
          ({ config, inputs', self', ... }: {
            packages = config.packages;
            stable = import inputs.nixpkgs-stable {
              system = architecture;
              config = { allowUnfree = true; };
            };
            inherit self' inputs' inputs;
          });
      in inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          { nixpkgs = { hostPlatform = architecture; }; }

          inputs.self.nixosModules.systemGenesis
          inputs.self.nixosModules.linux
          inputs.disko.nixosModules.disko
          inputs.impermanence.nixosModules.impermanence
          inputs.chaotic.nixosModules.default

          {
            systemGenesis = {
              architecture = "${architecture}";
              hostName = "${hostName}";
            };
          }
        ] ++ systemModules;
      };

    linuxUser = userName: homeConfiguration: {
      imports = with inputs.self.homeModules;
        [
          { h = { userName = "${userName}"; }; }
          paths
          tmux
          wmenu
          steam
          hyprland
          wayland
          fish
          rebuild
          dashalev
        ] ++ homeConfiguration;
    };
  };
}
