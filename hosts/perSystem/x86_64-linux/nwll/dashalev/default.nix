{ pkgs, inputs, self', ... }: {
  config.h = {
    dashalev.enable = true;
    xdg.configFiles = { "mpv/mpv.conf".source = ./mpv.conf; };

    packages = with pkgs; [
      foot
      pwvucontrol_git
      nautilus

      self'.packages.firefox
      (inputs.browser-previews.packages.${pkgs.system}.google-chrome-dev.override {
        # enableWideVine = true;
        # proprietaryCodecs = true;
        commandLineArgs =
          [ "--enable-features=WaylandLinuxDrmSyncobj,RustyPng" ];
      })

      # aseprite
      # legcord
      blender
      # krita
      # gimp3
      zathura

      signal-desktop-bin
      nvitop

      mpv
      # hdr for mpv
      vulkan-hdr-layer-kwin6

      mangohud_git
      # mullvad-vpn
      # qbittorrent
      # vesktop
      # heroic
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
        env = GBM_BACKEND,nvidia-drm
        env = LIBVA_DRIVER_NAME,nvidia
        env = __GLX_VENDOR_LIBRARY_NAME,nvidia
        env = __GL_GSYNC_ALLOWED,true
      '';
    };
  };
}
