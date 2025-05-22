{ pkgs, packages, inputs, ... }: {
  config.h = {
    dashalev.enable = true;
    steam.enable = true;

    xdg.configFiles = { "mpv/mpv.conf".source = ./mpv.conf; };

    packages = with pkgs; [
      foot
      pwvucontrol_git
      nautilus

      packages.firefox
      (chromium.override {
        enableWideVine = true;
        proprietaryCodecs = true;
        commandLineArgs =
          [ "--enable-features=WaylandLinuxDrmSyncobj,RustyPng" ];
      })

      # aseprite
      # legcord
      wine64
      blender
      # krita
      # gimp3
      zathura

      signal-desktop-bin
      nvitop

      mullvad-vpn
      mpv
      # hdr for mpv
      vulkan-hdr-layer-kwin6
      qbittorrent

      mangohud_git
      torzu_git
      heroic
      cemu
      prismlauncher
    ];

    shell = {
      package = pkgs.fish;
      colour = "magenta";
      icon = "🗿";
    };

    wayland = { enable = true; };

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
        env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      '';
    };
  };
}
