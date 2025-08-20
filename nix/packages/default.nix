{ inputs, self, lib, ... }: {
  perSystem = { system, pkgs, inputs', self', ... }: rec {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        inputs.chaotic.overlays.default
        (final: prev: {
          stable = import inputs.nixpkgs-stable {
            inherit (final) system;
            config.allowUnfree = true;
          };
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

      customPackages = let
        scriptDirs = lib.filterAttrs (_n: t: t == "directory")
          (builtins.readDir ./_custom);
      in builtins.listToAttrs (lib.mapAttrsToList (dirName: _: {
        name = dirName;
        value = import ./_custom/${dirName} {
          inherit inputs' self' self inputs lib pkgs;
        };
      }) scriptDirs);

    in wrapperPackages // customPackages // {
      neovim = inputs.mnw.lib.wrap pkgs (import ./_neovim pkgs);
    };
  };
}
