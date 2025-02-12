{ pkgs, ... }: {
  programs = {
    mpv = {
      enable = true;
      config = {
        hwdec = "nvdec";
        vo = "gpu";
        profile = "gpu-hq";
        gpu-context = "wayland";
      };
    };
  };

  xdg = {
    mimeApps = let browser = "brave-browser";
    in {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = "${browser}.desktop";
        "x-scheme-handler/https" = "${browser}.desktop";
      };
    };
  };

  services = {
    kanshi = {
      enable = true;
      settings = [
        {
          profile.outputs = [{
            criteria = "HDMI-A-1";
            status = "enable";
            mode = "3840x2160@120Hz";
          }];
        }
        {
          profile.outputs = [{
            criteria = "DP-4";
            status = "enable";
            mode = "3840x2160@165Hz";
          }];
        }
        {
          profile.outputs = [{
            criteria = "DP-2";
            status = "enable";
            mode = "3840x2160@165Hz";
          }];
        }
        {
          profile.outputs = [{
            criteria = "DP-3";
            status = "enable";
            mode = "3840x2160@165Hz";
          }];
        }
        {
          profile.outputs = [{
            criteria = "DP-1";
            status = "enable";
            mode = "3840x2160@165Hz";
          }];
        }
        {
          profile.outputs = [{
            criteria = "DP-0";
            status = "enable";
            mode = "3840x2160@165Hz";
          }];
        }
      ];
    };
  };

  h = {
    shell = {
      package = pkgs.fish;
      colour = "green";
      icon = "🗿";
    };

    foot.enable = true;
    wayland.enable = true;
    dunst.enable = true;

    wayland = { cursorTheme.size = 32; };
    river = {
      enable = true;
      extraConfig = ''
        pkill kanshi
        riverctl spawn "${pkgs.kanshi}/bin/kanshi &"
        pkill mpvpaper
        riverctl spawn "${pkgs.mpvpaper}/bin/mpvpaper -o 'no-audio --loop-playlist shuffle' '*' ${
          ./wallpapers/Black.Curtain.mp4
        }"
      '';
      # pkill wlclock
      # riverctl spawn "${pkgs.wlclock}/bin/wlclock --clock-colour '#ffffff' --background-colour '#00000000' --border-size 0 --exclusive-zone false --layer bottom --position top-right --size 230 --margin 20 --hand-width 2 --marking-width 2"
    };

    xdg.enable = true;
  };
}
