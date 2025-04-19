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
          general = with pkgs; [
            ripgrep
            fd

            # lsps
            stdenv.cc.cc
            vscode-langservers-extracted
            nil
            nixfmt-classic
            lua-language-server
            tailwindcss-language-server
            svelte-language-server
            typescript-language-server
            typescript
            mdx-language-server
            astro-language-server
            emmet-ls

            # school is the reason I have this garbage
            jdt-language-server
            pyright
            php83Packages.psalm
            intelephense

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

            nvim-treesitter.withAllGrammars

            lazydev-nvim
            nvim-lspconfig
            nvim-ts-autotag

            # conform-nvim

            comment-nvim
            nvim-autopairs

            friendly-snippets
            blink-cmp
          ];
        };

        optionalPlugins = {
          general = with pkgs.vimPlugins; [
            undotree
            zen-mode-nvim
            trouble-nvim

            # nvim-jdtls
          ];
        };
      };

      packageDefinitions.replace = {
        nvim = { pkgs, ... }: {
          settings = { wrapRc = true; };

          categories = { general = true; };
        };
      };
    };
  };
}
