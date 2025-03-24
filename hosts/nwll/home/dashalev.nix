{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      (writeShellApplication {
        name = "cider";
        runtimeInputs = [ appimage-run ];
        text = ''
          appimage-run ~/.local/bin/cider-linux-x64.AppImage
        '';
      })
    ];

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
    mimeApps = let browser = "zen";
    in {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = "${browser}.desktop";
        "x-scheme-handler/https" = "${browser}.desktop";
      };
    };
  };

  # services = {
  #   kanshi = {
  #     enable = true;
  #     settings = [
  #       {
  #         profile.outputs = [{
  #           criteria = "HDMI-A-1";
  #           status = "enable";
  #           mode = "3840x2160@120Hz";
  #         }];
  #       }
  #       {
  #         profile.outputs = [{
  #           criteria = "DP-4";
  #           status = "enable";
  #           mode = "3840x2160@165Hz";
  #         }];
  #       }
  #       {
  #         profile.outputs = [{
  #           criteria = "DP-2";
  #           status = "enable";
  #           mode = "3840x2160@165Hz";
  #         }];
  #       }
  #       {
  #         profile.outputs = [{
  #           criteria = "DP-3";
  #           status = "enable";
  #           mode = "3840x2160@165Hz";
  #         }];
  #       }
  #       {
  #         profile.outputs = [{
  #           criteria = "DP-1";
  #           status = "enable";
  #           mode = "3840x2160@165Hz";
  #         }];
  #       }
  #       {
  #         profile.outputs = [{
  #           criteria = "DP-0";
  #           status = "enable";
  #           mode = "3840x2160@165Hz";
  #         }];
  #       }
  #     ];
  #   };
  # };

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

    hyprland = {
      enable = true;
      extraConfig = ''
        monitor=HDMI-A-1,highrr,auto,1
        monitor=DP-0,highres@highrr,auto,1
        monitor=DP-1,highres@highrr,auto,1
        monitor=DP-2,highres@highrr,auto,1
        monitor=DP-3,highres@highrr,auto,1
        monitor=DP-4,highres@highrr,auto,1
        env = LIBVA_DRIVER_NAME,nvidia
        env = NVD_BACKEND,direct
      '';

      # env = __GLX_VENDOR_LIBRARY_NAME,nvidia

      # monitor=HDMI-A-1,highrr,auto,1,bitdepth,10
      # monitor=DP-0,highres@highrr,auto,1,bitdepth,10
      # monitor=DP-1,highres@highrr,auto,1,bitdepth,10
      # monitor=DP-2,highres@highrr,auto,1,bitdepth,10
      # monitor=DP-3,highres@highrr,auto,1,bitdepth,10
      # monitor=DP-4,highres@highrr,auto,1,bitdepth,10

      # bitdepth,10
    };

    river = {
      enable = false;
      extraConfig = ''
        pkill kanshi
        riverctl spawn "${pkgs.kanshi}/bin/kanshi &"
      '';
    };

    xdg.enable = true;
  };
}
