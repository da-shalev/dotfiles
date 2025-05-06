{ pkgs, ... }: {
  config.h = {
    shell = {
      package = pkgs.fish;
      colour = "green";
      icon = "📦";
    };

    dashalev.enable = true;
    wayland = {
      enable = true;
      cursorTheme.size = 16;
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
