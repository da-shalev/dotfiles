{ pkgs, ... }: {
  #   mpv = {
  #     # chaotic nyx
  #     package = pkgs.mpv-vapoursynth;
  #     enable = true;
  #     config = {
  #       vo = "gpu-next";
  #       gpu-api = "vulkan";
  #       target-colorspace-hint = "yes";
  #       gpu-context = "waylandvk";
  #       fs = "yes";
  #     };
  #   };
  # };

  # xdg = {
  #   mimeApps = let browser = "brave-browser";
  #   in {
  #     enable = true;
  #     defaultApplications = {
  #       "x-scheme-handler/http" = "${browser}.desktop";
  #       "x-scheme-handler/https" = "${browser}.desktop";
  #     };
  #   };
  # };

  config.h = {
    dashalev.enable = true;
    steam.enable = true;

    shell = {
      package = pkgs.fish;
      colour = "magenta";
      icon = "🗿";
    };

    foot.enable = true;
    wayland = {
      enable = true;
      cursorTheme.size = 32;
    };

    hyprland = {
      enable = true;
      extraConfig = ''
        monitor=HDMI-A-1,highrr,auto,1
        monitor=DP-0,highres@highrr,auto,1,bitdepth
        monitor=DP-1,highres@highrr,auto,1,bitdepth
        monitor=DP-2,highres@highrr,auto,1,bitdepth
        monitor=DP-3,highres@highrr,auto,1,bitdepth
        monitor=DP-4,highres@highrr,auto,1,bitdepth
        env = LIBVA_DRIVER_NAME,nvidia
        env = NVD_BACKEND,direct
        env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      '';
    };
  };
}
