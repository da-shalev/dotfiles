{ config, lib, pkgs, ... }: {
  imports = [ ./hyprland ];

  dconf.settings = {
    "/org/gnome/desktop/interface/color-scheme" = "prefer-dark";
    "/org/gnome/desktop/wm/preferences/button-layout" = "";
  };

  wayland = {
    cursor_theme = {
      name = "macOS";
      package = pkgs.apple-cursor;
      size = lib.mkDefault 40;
    };

    icon_theme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;
    };
  };

  user_dirs = {
    XDG_DESKTOP_DIR = lib.mkDefault "$HOME/";
    XDG_DOCUMENTS_DIR = lib.mkDefault "$HOME/dox";
    XDG_DOWNLOAD_DIR = lib.mkDefault "$HOME/dow";
    XDG_MUSIC_DIR = lib.mkDefault "$HOME/";
    XDG_PICTURES_DIR = lib.mkDefault "$HOME/pix";
    XDG_PUBLICSHARE_DIR = lib.mkDefault "$HOME/media";
    XDG_TEMPLATES_DIR = lib.mkDefault "$HOME/";
    XDG_VIDEOS_DIR = lib.mkDefault "$HOME/vid";
  };

  # XDG compliance
  file = {
    xdg_config = {
      "npm/npmrc".text = ''
        cache=$XDG_CACHE_HOME/npm
      '';
      "git/ignore".source = ./git/ignore;
      "git/config".source = ./git/config;
      "mimeapps.list".source = ./mimeapps.list;
    } // lib.optionalAttrs (builtins.elem pkgs.foot config.packages) {
      "foot/foot.ini".source = ./foot.ini;
    } // lib.optionalAttrs (builtins.elem pkgs.lsd config.packages) {
      "lsd/config.yaml".source = ./lsd.yaml;
    } // lib.optionalAttrs
      (builtins.elem pkgs.tmux-sessionizer config.packages) {
        "tms/config.toml".source = ./tms.toml;
      } // lib.optionalAttrs (builtins.elem pkgs.mpv config.packages) {
        "mpv/mpv.conf".source = ./mpv.conf;
      };
  };

  dirs = [ "$XDG_DATA_HOME/wineprefixes" "$XDG_STATE_HOME/bash" ];
  shell = rec {
    aliases = { s = "${lib.getExe pkgs.lsd} -lA"; };
    paths =
      [ "${variables.NPM_CONFIG_PREFIX}/bin" "${variables.CARGO_HOME}/bin" ];
    variables = {
      JAVA_HOME = "${pkgs.jdk21}";
      JAVA_RUN = "${lib.getExe' pkgs.jdk21 "java"}";
      JDK21 = pkgs.jdk21;

      MOZ_CRASHREPORTER_DISABLE = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
      EDITOR = "nvim";
      QT_SCALE_FACTOR = 1.5;
      FZF_DEFAULT_OPTS = "--height=100% --layout=reverse --exact";
      GOPATH = "$XDG_DATA_HOME/go";
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
      NPM_CONFIG_PREFIX = "$XDG_DATA_HOME/npm";
      NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
      LESSHISTFILE = "/dev/null";

      # XDG compliance
      WINEPREFIX = "$XDG_DATA_HOME/wineprefixes/default";
      HISTFILE = "$XDG_STATE_HOME/bash/history";
      WGETRC = "$XDG_CONFIG_HOME/wgetrc";
      OMNISHARPHOME = "$XDG_CONFIG_HOME/omnisharp";
      MAVEN_OPTS = "-Dmaven.repo.local=$XDG_DATA_HOME/maven/repository";
      MAVEN_ARGS = "--settings $XDG_CONFIG_HOME/maven/settings.xml";
      NUGET_PACKAGES = "$XDG_CACHE_HOME/NuGetPackages";
      # java fonts
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java";
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      GNUPGHOME = "$XDG_DATA_HOME/gnupg";
    };
  };

  packages = with pkgs; [
    lsd
    tmux-sessionizer
    woff2
    ripgrep
    jq
    yq
    fd
    fzf

    nodePackages_latest.npm
    bun
    nodejs

    smartmontools
    pinentry-tty
    imagemagick
    exiftool

    # inputs'.self.packages.neovim
    mpv
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

    plugins = with pkgs.fishPlugins; [ puffer autopair ];

    interactive = ''
      ${builtins.readFile ./fish/config.fish}

      function fish_prompt
        printf '%s%s%s %s%s%s\n%s ' \
          (set_color "${config.shell.colour}")(whoami) \
          (set_color "brwhite")@ \
          (set_color "bryellow")(hostname) \
          (set_color "brgreen") (prompt_pwd) \
          (set_color "brred"; fish_git_prompt) \
          ${config.shell.icon}
      end
    '';
  };
}
