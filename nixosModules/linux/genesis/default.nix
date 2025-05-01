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
          {
            nixpkgs = { hostPlatform = architecture; };
            home-manager.extraSpecialArgs = specialArgs;
          }

          inputs.self.nixosModules.systemGenesis
          inputs.self.nixosModules.linux
          inputs.disko.nixosModules.disko
          inputs.home-manager.nixosModules.home-manager
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
        imports = [ ./home-manager.nix ];
        home-manager = {
          users.${userName} = {
            imports = with inputs.self.homeModules;
              [
                {
                  h = {
                    homePath = "${homePath}";
                    userName = "${userName}";
                  };
                }
                paths
                foot
                dev
                git
                tmux
                fzf
                fd
                fish
                wmenu
                wayland
                hyprland
                dunst
                lsd
                xdg
                ghostty
                nixCats
              ] ++ homeConfiguration;
          };
        };

        users.users.${userName} = {
          name = "${userName}";
          home = "${homePath}";
          isNormalUser = true;
          initialPassword = "boobs";
          extraGroups = [ "wheel" "video" "networkmanager" ];
        };
      };
  };
}
