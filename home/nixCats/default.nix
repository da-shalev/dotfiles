{ inputs, config, lib, ... }:
let inherit (inputs.nixCats) utils;
in {
  imports = [ inputs.nixCats.homeModule ];

  options.h.nixCats.defaultEditor = lib.mkOption {
    type = with lib.types; nonEmptyStr;
    default = "nvim";
  };

  config = {
    home = {
      sessionVariables.EDITOR = "${config.h.nixCats.defaultEditor}";
      shellAliases = {
        nvim = "${config.h.nixCats.defaultEditor}";
        vim = "${config.h.nixCats.defaultEditor}";
        vi = "${config.h.nixCats.defaultEditor}";
        v = "${config.h.nixCats.defaultEditor}";
      };
    };

    nixCats = {
      enable = true;
      nixpkgs_version = inputs.nixpkgs;
      addOverlays = [ (utils.standardPluginOverlay inputs) ];
      packageNames = [ "nvim" ];

      luaPath = "${./.}";
      categoryDefinitions.replace = { pkgs, settings, categories, name, ... }: {
        lspsAndRuntimeDeps = {
          general = with pkgs; [ ripgrep fd ];

          # NOTE: this includes generic lsps with specific ones
          # expected to be loaded utilizing direnv(s)
          lsps-enabled = with pkgs; [
            # lsps
            stdenv.cc.cc
            vscode-langservers-extracted
            nil
            nixfmt-classic
            lua-language-server
            tailwindcss-language-server
            typescript-language-server
            mdx-language-server
            astro-language-server
            emmet-ls

            # school is the reason I have this garbage
            jdt-language-server
            pyright
            php83Packages.psalm
            intelephense

            # utils
            maven
            dotnet-sdk_9

            # fmt + linter
            deadnix
            statix
            editorconfig-checker
            ruff
            mypy
            jq
            yq
            shfmt
          ];
        };

        startupPlugins = {
          general = with pkgs.vimPlugins; [
            gruvbox-nvim
            lualine-nvim
            telescope-nvim
            vim-tmux-navigator

            todo-comments-nvim
            nvim-colorizer-lua

            nvim-treesitter.withAllGrammars
          ];

          lsps-enabled = with pkgs.vimPlugins; [
            lazydev-nvim
            nvim-lspconfig
            nvim-ts-autotag

            conform-nvim

            comment-nvim
            nvim-autopairs

            friendly-snippets
            blink-cmp
            crates-nvim
          ];
        };

        optionalPlugins = {
          general = with pkgs.vimPlugins; [
            undotree
            zen-mode-nvim
            trouble-nvim
          ];

          lsps-enabled = with pkgs.vimPlugins; [ nvim-jdtls ];
        };
      };

      packageDefinitions.replace = {
        nvim = { pkgs, ... }: {
          settings = { wrapRc = true; };

          categories = {
            general = true;
            lsps-enabled = true;
          };
        };
      };
    };
  };
}
