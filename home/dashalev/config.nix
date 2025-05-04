{ packages, config, lib, pkgs, ... }: {
  h = {
    git = {
      enable = true;
      config = "${builtins.readFile ./git/config}";
      ignore = "${builtins.readFile ./git/ignore}";
    };

    rebuild.enable = true;

    shell = {
      aliases = { s = "${lib.getExe pkgs.lsd} -lA"; };
      variables = rec {
        FZF_DEFAULT_OPTS = "--height=100% --layout=reverse --exact";
        GOPATH = "${config.h.xdg.dataHome}/go";
        NPM_CONFIG_PREFIX = "${config.h.xdg.dataHome}/npm";
        NPM_CONFIG_USERCONFIG = "${config.h.xdg.configHome}/npm/config";
        CARGO_HOME = "${config.h.xdg.dataHome}/cargo";
        LESSHISTFILE = "/dev/null";
        JAVA_HOME = "${pkgs.jdk21}";
        JAVA_RUN = "${pkgs.jdk21}/bin/java";
        JDK21 = pkgs.jdk21;
        PATH = "${NPM_CONFIG_PREFIX}/bin:${CARGO_HOME}/bin:$PATH";
      };
    };

    packages = with pkgs; [
      lsd
      tmux-sessionizer
      woff2
      ripgrep
      jq
      fd
      fzf

      nodePackages_latest.npm
      nodejs

      smartmontools
      pinentry-tty
      imagemagick
      exiftool

      packages.neovim
    ];

    tmux = {
      enable = true;
      config = "${builtins.readFile ./tmux.conf}";
      plugins = with pkgs.tmuxPlugins; [ yank vim-tmux-navigator ];
    };

    foot = { config = "${builtins.readFile ./foot.ini}"; };

    fish = {
      enable = true;
      interactive = ''
        ${builtins.readFile ./config.fish}

        function fish_prompt
          printf '%s%s%s %s%s%s\n%s ' \
            (set_color "${config.h.shell.colour}")(whoami) \
            (set_color "brwhite")@ \
            (set_color "bryellow")(hostname) \
            (set_color "brgreen") (prompt_pwd) \
            (set_color "brred"; fish_git_prompt) \
            ${config.h.shell.icon}
        end
      '';
    };
  };

  environment.etc = config.h.profile.addConfigs {
    "ghostty/config".source = ./ghostty.conf;
    "fish/themes/fishsticks.theme".source = ./fishsticks.theme;
    "tms/config.toml".text = ''
      excluded_dirs = [".direnv"]

      [[search_dirs]]
      path = "${config.systemGenesis.configPath}/"
      depth = 5

      [[search_dirs]]
      path = "${config.h.path}/media/"
      depth = 20
    '';
    "lsd/config.yaml".source = ./lsd.yaml;
    "npm/config".text = ''
      cache=${config.h.xdg.cacheHome}/npm
    '';
  };
}
