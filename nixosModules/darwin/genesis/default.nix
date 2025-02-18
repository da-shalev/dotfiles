{ inputs, withSystem, ... }: {
  _module.args = {
    darwinGenesis = architecture: hostName: systemModules:
      let
        specialArgs = withSystem architecture
          ({ config, pkgs, inputs', self', ... }: {
            packages = config.packages;
            inherit self' inputs' inputs;
          });
      in inputs.nix-darwin.lib.darwinSystem {
        inherit specialArgs;
        modules = [
          {
            nixpkgs = { hostPlatform = architecture; };
            home-manager.extraSpecialArgs = specialArgs;
          }

          inputs.self.nixosModules.systemGenesis
          inputs.self.nixosModules.darwin
          inputs.home-manager.darwinModules.home-manager

          {
            systemGenesis = {
              architecture = "${architecture}";
              hostName = "${hostName}";
            };
          }
        ] ++ systemModules;
      };

    darwinUser = userName: homeConfiguration:
      let homePath = "/Users/${userName}";
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
                dev
                git
                ghostty
                tmux
                fzf
                fd
                fish
                lsd
                scripts
                nixCats
              ] ++ homeConfiguration;

            home.stateVersion = "25.05";
          };
        };

        users.users.${userName} = {
          name = "${userName}";
          home = "${homePath}";
        };
      };
  };
}
