{ moduleWithSystem, lib, ... }:
{
  flake.modules.maid.dashalev = moduleWithSystem (
    { pkgs }:
    {
      config,
      ...
    }:
    {
      dconf.settings = {
        "/org/gnome/desktop/interface/color-scheme" = "prefer-dark";
        "/org/gnome/desktop/wm/preferences/button-layout" = "";
      };

      wayland = {
        cursor_theme = {
          name = "macOS";
          package = pkgs.apple-cursor;
        };
      };

      user_dirs = {
        XDG_DOCUMENTS_DIR = lib.mkDefault "$HOME/media/dox";
        XDG_MUSIC_DIR = lib.mkDefault "$HOME/media/mus";
        XDG_VIDEOS_DIR = lib.mkDefault "$HOME/media/vid";
        XDG_PICTURES_DIR = lib.mkDefault "$HOME/media/pix";
        XDG_DOWNLOAD_DIR = lib.mkDefault "$HOME/media/dow";

        XDG_DESKTOP_DIR = lib.mkDefault "$HOME/";
        XDG_PUBLICSHARE_DIR = lib.mkDefault "$HOME/";
        XDG_TEMPLATES_DIR = lib.mkDefault "$HOME/";
      };

      # XDG compliance
      file.xdg_config = {
        "git/ignore".source = ./git/ignore;
        "git/config".source = ./git/config;
        "mpd/mpd.conf".source = ./mpd.conf;
        "rpmc/config.ron".source = ./rmpc/config.ron;
        "mimeapps.list".source = ./mimeapps.list;
        "fnott/fnott.ini".text = ''
          ${builtins.readFile ./fnott/fnott.ini}
          play-sound=${lib.getExe' pkgs.pipewire "pw-play"} ''${filename}

          [critical]
          border-color=fb4934ff
          sound-file=${./fnott/critical.flac}

          [normal]
          border-color=b16286FF
          sound-file=${./fnott/info.flac}

          [low]
          border-color=b16286FF
        '';
        "foot/foot.ini".source = ./foot.ini;
        "lsd/config.yaml".source = ./lsd.yaml;
        "tms/config.toml".source = ./tms.toml;
        "mpv/mpv.conf".source = ./mpv.conf;
        "fd/ignore".source = ./fd_ignore;
      };

      dirs = [ "$XDG_STATE_HOME/bash" ];
      shell = {
        package = lib.mkDefault pkgs.fish;
        aliases = {
          s = "${lib.getExe pkgs.lsd} -lA";
        };
        variables = {
          JAVA_HOME = "${pkgs.jdk21}";
          JAVA_RUN = "${lib.getExe' pkgs.jdk21 "java"}";
          JDK21 = pkgs.jdk21;
          MOZ_CRASHREPORTER_DISABLE = "1";
          NIXPKGS_ALLOW_UNFREE = "1";
          EDITOR = "nvim";
          QT_SCALE_FACTOR = 1.5;
          FZF_DEFAULT_OPTS = ''
            --height=100%
            --layout=reverse
            --bind 'ctrl-o:execute(test -f {1} && xdg-open {1})+accept'
            --bind 'ctrl-e:execute(nvim {1})+abort'
          '';
        };
      };

      packages =
        with pkgs;
        [
          lsd
          tmux-sessionizer
          woff2
          ripgrep
          jq
          yq
          fd
          npins

          bun
          nodejs

          smartmontools

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
          treefmt
          rsync

          exiftool

          # music stuff
          spek
          beets
          python313Packages.audiotools
          flac
          eyed3
          rmpc
          mpc

          da.neovim
          da.fzf-media
          da.fzf
          da.da-song
          da.da-date
          da.da-time
          pulsemixer
          bluetuith
        ]
        ++ lib.optionals config.hyprland.enable [
          da.firefox
          da.wmenu
          nautilus
          zathura
          foot
          love
          aseprite
          vscode
        ];

      tmux = {
        enable = true;
        config = ''
          ${builtins.readFile ./tmux.conf}
        '';
        plugins = with pkgs.tmuxPlugins; [ yank ];
      };

      systemd.services.mpd-tmux = {
        description = "Refresh tmux status on MPD song changes";

        serviceConfig = {
          Type = "simple";
          ExecStart = ''
            ${lib.getExe pkgs.bash} -c '${lib.getExe pkgs.mpc} idleloop player | while read event; do ${lib.getExe pkgs.tmux} refresh-client -S 2>/dev/null || true; done'
          '';
          Restart = "always";
          RestartSec = "5";
        };

        wantedBy = [ "default.target" ];
      };

      fish = {
        enable = true;
        themes = [
          {
            name = "fishsticks";
            source = ./fish/fishsticks.theme;
          }
        ];

        plugins = with pkgs.fishPlugins; [
          puffer
          autopair
        ];

        interactive = ''
          ${builtins.readFile ./fish/config.fish}
        '';
      };
    }
  );
}
