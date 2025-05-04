pkgs: {
  appName = "nvim";
  desktopEntry = false;

  providers = {
    python3.enable = false;
    ruby.enable = false;
    perl.enable = false;
    nodeJs.enable = false;
  };

  initLua = builtins.readFile ./init.lua;

  plugins = with pkgs.vimPlugins; [
    ./.

    gruvbox-nvim
    lualine-nvim
    telescope-nvim
    vim-tmux-navigator

    todo-comments-nvim

    nvim-treesitter.withAllGrammars

    lazydev-nvim
    nvim-lspconfig
    nvim-ts-autotag

    comment-nvim
    nvim-autopairs

    friendly-snippets
    blink-cmp

    # undotree
    # zen-mode-nvim
    # trouble-nvim
  ];

  extraBinPath = with pkgs; [
    ripgrep
    fd
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

    jdt-language-server
    pyright
    php83Packages.psalm
    # intelephense

    deadnix
    statix
    editorconfig-checker
    ruff
    mypy
    jq
    yq
    shfmt
  ];

  aliases = [ "vi" "v" "vim" ];
}
