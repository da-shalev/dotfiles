{ inputs, ... }: {
  flake.modules.maid.dashalev = { config, lib, pkgs, ... }: {
    imports = [ ./_hyprland ];

    gsettings.package = let
      gsettings-declarative =
        import "${inputs.nix-maid}/gsettings-declarative" { inherit pkgs; };
    in gsettings-declarative.overrideAttrs (prevAttrs: {
      nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ pkgs.glib ];
      buildInputs = prevAttrs.buildInputs or [ ]
        ++ [ pkgs.gsettings-desktop-schemas ];
    });

    dconf.settings = {
      "/org/gnome/desktop/interface/color-scheme" = "prefer-dark";
      "/org/gnome/desktop/wm/preferences/button-layout" = "";
    };

    wayland = {
      cursor_theme = {
        name = "macOS";
        package = pkgs.apple-cursor;
      };

      # icon_theme = {
      #   name = "WhiteSur-dark";
      #   package = pkgs.whitesur-icon-theme;
      # };
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
    file.xdg_config = {
      # gotta love npm
      "npm/npmrc".text = ''
        cache=/home/dashalev/.cache/npm
      '';
      "git/ignore".source = ./git/ignore;
      "git/config".source = ./git/config;
      "mimeapps.list".source = ./mimeapps.list;
      "mako/config".source = ./mako;
      "foot/foot.ini".source = ./foot.ini;
      "lsd/config.yaml".source = ./lsd.yaml;
      "tms/config.toml".source = ./tms.toml;
      "mpv/mpv.conf".source = ./mpv.conf;
    };

    dirs = [ "$XDG_STATE_HOME/bash" "$XDG_DATA_HOME/wineprefixes" ];
    shell = rec {
      aliases = { s = "${lib.getExe pkgs.lsd} -lA"; };
      paths = [ "${variables.CARGO_HOME}/bin" ];
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
        NPM_CONFIG_PREFIX = "$XDG_CONFIG_HOME/npm";
        NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
        LESSHISTFILE = "/dev/null";

        # XDG compliance
        HISTFILE = "$XDG_STATE_HOME/bash/history";
        WGETRC = "$XDG_CONFIG_HOME/wgetrc";
        MAVEN_OPTS = "-Dmaven.repo.local=$XDG_DATA_HOME/maven/repository";
        MAVEN_ARGS = "--settings $XDG_CONFIG_HOME/maven/settings.xml";
        NUGET_PACKAGES = "$XDG_CACHE_HOME/NuGetPackages";
        OMNISHARPHOME = "$XDG_CONFIG_HOME/omnisharp";
        # java fonts
        _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java";
        CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        GNUPGHOME = "$XDG_DATA_HOME/gnupg";
        WINEPREFIX = "$XDG_DATA_HOME/wineprefixes/default";
      };
    };

    packages = with pkgs; [
      # GLOBAL DASHALEV PACKAGES
      lsd
      tmux-sessionizer
      woff2
      ripgrep
      jq
      yq
      fd
      fzf
      npins

      inputs.self.packages.${pkgs.system}.neovim
      inputs.self.packages.${pkgs.system}.zen-browser

      bun
      nodejs
      deno

      smartmontools
      exiftool

      mpv

      ffmpeg-full
      yt-dlp
      wget
      unzip
      p7zip
      zip
      tree
      vimv
      onefetch
      fastfetch
      btop
      htop
      dysk
      bat
      hyperfine

      asciiquarium-transparent
      nyancat
      cmatrix
      sl
      nix-tree
      rsync

      foot
      pulsemixer
    ];

    tmux = {
      enable = true;
      config = ''
        ${builtins.readFile ./tmux.conf}
      '';
      plugins = with pkgs.tmuxPlugins; [ yank ];
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
      '';
    };
  };
}
