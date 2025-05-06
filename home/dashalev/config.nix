{ packages, config, lib, pkgs, ... }: {
  h = {
    rebuild.enable = true;
    wayland = {
      dconf = {
        "/org/gnome/desktop/interface/color-scheme" = "prefer-dark";
        "/org/gnome/desktop/wm/preferences/button-layout" = "";
      };

      # iconTheme = {
      #   name = "WhiteSur-dark";
      #   package = pkgs.whitesur-icon-theme;
      # };
    };

    # XDG compliance
    xdg = {
      dirs = [
        "${config.h.xdg.dataHome}/wineprefixes"
        "${config.h.xdg.stateHome}/bash"
      ];

      configFiles = {
        "npm/npmrc".text = ''
          cache=${config.h.xdg.cacheHome}/npm
        '';
        "git/ignore".source = ./git/ignore;
        "git/config".source = ./git/config;
        "ghostty/config".source = ./ghostty.conf;
      } // lib.optionalAttrs (builtins.elem pkgs.foot config.h.packages) {
        "foot/foot.ini".source = ./foot.ini;
      } // lib.optionalAttrs (builtins.elem pkgs.lsd config.h.packages) {
        "lsd/config.yaml".source = ./lsd.yaml;
      } // lib.optionalAttrs
        (builtins.elem pkgs.tmux-sessionizer config.h.packages) {
          "tms/config.toml".text = ''
            excluded_dirs = [".direnv"]

            [[search_dirs]]
            path = "${config.systemGenesis.configPath}/"
            depth = 5

            [[search_dirs]]
            path = "${config.h.path}/media/"
            depth = 20
          '';
        };
    };

    shell = {
      aliases = { s = "${lib.getExe pkgs.lsd} -lA"; };
      variables = rec {
        EDTIOR = "nvim";
        QT_SCALE_FACTOR = 1.5;
        FZF_DEFAULT_OPTS = "--height=100% --layout=reverse --exact";
        GOPATH = "${config.h.xdg.dataHome}/go";
        CARGO_HOME = "${config.h.xdg.dataHome}/cargo";
        JAVA_HOME = "${pkgs.jdk21}";
        JAVA_RUN = "${pkgs.jdk21}/bin/java";
        JDK21 = pkgs.jdk21;
        NPM_CONFIG_PREFIX = "${config.h.xdg.configHome}/npmrc";
        NPM_CONFIG_USERCONFIG = "${config.h.xdg.configHome}/npm/config";
        LESSHISTFILE = "/dev/null";
        PATH = "${NPM_CONFIG_PREFIX}/bin:${CARGO_HOME}/bin:$PATH";

        # XDG compliance
        # _JAVA_OPTIONS =
        #   ''-Djava.util.prefs.userRoot="${config.h.xdg.configHome}/java"'';
        WINEPREFIX = "${config.h.xdg.dataHome}/wineprefixes/default";
        HISTFILE = "${config.h.xdg.stateHome}/bash/history";
        WGETRC = "${config.h.xdg.configHome}/wgetrc";
        OMNISHARPHOME = "${config.h.xdg.configHome}/omnisharp";
        MAVEN_OPTS =
          "-Dmaven.repo.local=${config.h.xdg.dataHome}/maven/repository";
        MAVEN_ARGS = "--settings ${config.h.xdg.configHome}/maven/settings.xml";
        NUGET_PACKAGES = "${config.h.xdg.cacheHome}/NuGetPackages";
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

    fish = {
      enable = true;
      themes = [{
        name = "fishsticks";
        source = ./fish/fishsticks.theme;
      }];
      interactive = ''
        ${builtins.readFile ./fish/config.fish}

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
}
