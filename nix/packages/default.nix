{ inputs, self, lib, ... }: {
  perSystem = { system, pkgs, inputs', self', ... }: rec {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = with inputs; [
        chaotic.overlays.default

        (final: prev: {
          stable = import inputs.nixpkgs-stable {
            inherit (final) system;
            config.allowUnfree = true;
          };

          user = packages;
        })
      ];
    };

    packages = let
      wrapperPackages = (inputs.wrapper-manager.lib {
        inherit (_module.args) pkgs;
        modules = let
          dirNames = builtins.attrNames
            (lib.filterAttrs (_n: t: t == "directory")
              (builtins.readDir ./_wrapper-manager));
        in map (n: ./_wrapper-manager/${n}) dirNames;
        specialArgs = { inherit self inputs'; };
      }).config.build.packages;

      userPackages = let
        scriptDirs =
          lib.filterAttrs (_n: t: t == "directory") (builtins.readDir ./_user);
      in builtins.listToAttrs (lib.mapAttrsToList (dirName: _: {
        name = dirName;
        value = import ./_user/${dirName} { inherit inputs' inputs lib pkgs; };
      }) scriptDirs);

    in wrapperPackages // userPackages // {
      neovim = inputs.mnw.lib.wrap pkgs (import ./_neovim pkgs);
    };
  };
}
