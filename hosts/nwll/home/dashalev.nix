{ packages, pkgs, ... }: {
  config.h = {
    dashalev.enable = true;
    steam.enable = true;

    xdg.configFiles = {
      "mpv/mpv.conf".source = ./mpv.conf;
    };

    packages = with pkgs; [
      foot
      pwvucontrol_git
      nautilus
      chromium
      (brave.override {
        commandLineArgs =
          [ "--enable-features=WaylandLinuxDrmSyncobj,RustyPng" ];
      })

      # aseprite
      # vesktop
      wine64
      blender
      # krita
      # gimp3
      onlyoffice-desktopeditors

      zathura

      signal-desktop-bin
      nvitop

      mullvad-vpn
      mpv
      # hdr for mpv
      vulkan-hdr-layer-kwin6
      qbittorrent

      mangohud
      torzu_git
      heroic
      cemu
      prismlauncher
      airshipper
    ];

    shell = {
      package = pkgs.fish;
      colour = "magenta";
      icon = "🗿";
    };

    wayland = {
      enable = true;
      cursorTheme.size = 32;
    };

    hyprland = {
      enable = true;
      extraConfig = ''
        monitor=HDMI-A-1,highrr,auto,1
        monitor=DP-0,highres@highrr,auto,1,bitdepth,10
        monitor=DP-1,highres@highrr,auto,1,bitdepth,10
        monitor=DP-2,highres@highrr,auto,1,bitdepth,10
        monitor=DP-3,highres@highrr,auto,1,bitdepth,10
        monitor=DP-4,highres@highrr,auto,1,bitdepth,10
        env = LIBVA_DRIVER_NAME,nvidia
        env = NVD_BACKEND,direct
        env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      '';
    };
  };
}
