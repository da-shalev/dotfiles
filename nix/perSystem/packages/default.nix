{
  inputs,
  self,
  lib,
  ...
}:
{
  perSystem =
    {
      system,
      pkgs,
      inputs',
      self',
      ...
    }:
    rec {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            stable = import inputs.nixpkgs-stable {
              inherit (final) system;
              config.allowUnfree = true;
            };

            da = packages;
          })

          inputs.nvim-treesitter-main.overlays.default
          (final: prev: {
            vimPlugins = prev.vimPlugins.extend (
              f: p: {
                nvim-treesitter = p.nvim-treesitter.withAllGrammars; # or withPlugins...
                # also redefine nvim-treesitter-textobjects (any other plugins that depend on nvim-treesitter)
                nvim-treesitter-textobjects = p.nvim-treesitter-textobjects.overrideAttrs {
                  dependencies = [ f.nvim-treesitter ];
                };
              }
            );
          })

          inputs.nix-vscode-extensions.overlays.default
        ];
      };

      packages =
        let
          wrapperPackages =
            (inputs.wrapper-manager.lib {
              inherit (_module.args) pkgs;
              modules =
                let
                  dirNames = builtins.attrNames (
                    lib.filterAttrs (_n: t: t == "directory") (builtins.readDir ./_wrapper-manager)
                  );
                in
                map (n: ./_wrapper-manager/${n}) dirNames;
              specialArgs = { inherit self inputs'; };
            }).config.build.packages;

          daPackages =
            let
              scriptDirs = lib.filterAttrs (_n: t: t == "directory") (builtins.readDir ./_da);
            in
            builtins.listToAttrs (
              lib.mapAttrsToList (dirName: _: {
                name = dirName;
                value = import ./_da/${dirName} {
                  inherit
                    inputs'
                    inputs
                    lib
                    pkgs
                    ;
                };
              }) scriptDirs
            );
        in
        wrapperPackages
        // daPackages
        // {
          neovim = inputs.mnw.lib.wrap pkgs (import ./_neovim pkgs);
        };
    };
}
