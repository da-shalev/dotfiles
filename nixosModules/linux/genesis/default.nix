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

          {
            systemGenesis = {
              architecture = "${architecture}";
              hostName = "${hostName}";
            };
          }
        ] ++ systemModules;
      };

    linuxUser = userName: homeConfiguration:
      let homePath = "/home/${userName}";
      in {
        imports = with inputs.self.homeModules;
          [
            {
              h = {
                userName = "${userName}";
                path = "${homePath}";
              };
            }
            paths
            foot
            tmux
            wmenu
            steam
            git
            hyprland
            wayland
            fish
            rebuild
            dashalev
          ] ++ homeConfiguration;
      };
  };
}
