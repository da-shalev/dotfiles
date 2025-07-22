{ pkgs, lib, self', self, inputs', ... }: {
  programs.fish.enable = true;
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.hyprland = {
    enable = true;
    package = inputs'.hyprland.packages.hyprland;
    portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
  };

  xdg.portal.config.common = { hyprland = [ "hyprland" "gtk" ]; };

  users.users.dashalev = {
    uid = 1000;
    extraGroups = [ "wheel" "video" "networkmanager" "steam" "libvirt" ];
    isNormalUser = true;
    shell = pkgs.fish;
    initialPassword = "boobs";

    maid = {
      imports = [
        self.modules.maid.shell
        self.modules.maid.wayland
        self.modules.maid.tmux
        self.modules.maid.fish
        self.modules.maid.hyprland
        self.modules.maid.dashalev
      ];

      packages = with pkgs; [
        foot
        pwvucontrol_git
        nautilus

        (brave.override {
          commandLineArgs =
            [ "--enable-features=WaylandLinuxDrmSyncobj,RustyPng" ];
        })

        # aseprite
        blender
        # krita
        # gimp3
        zathura

        signal-desktop-bin
        nvitop

        mangohud
        mullvad-vpn
        # nicotine-plus
        # qbittorrent
        # heroic
      ];

      shell = {
        package = pkgs.fish;
        colour = "magenta";
        icon = "🗿";
      };

      hyprland = {
        enable = true;
        extraConfig = ''
          monitor=HDMI-A-1,highrr,auto,1
          monitor=DP-0,highres@highrr,auto,1
          monitor=DP-1,highres@highrr,auto,1
          monitor=DP-2,highres@highrr,auto,1
          monitor=DP-3,highres@highrr,auto,1
          monitor=DP-4,highres@highrr,auto,1
          monitor=Virtual-1,highres@highrr,auto,1
          env = GBM_BACKEND,nvidia-drm
          env = LIBVA_DRIVER_NAME,nvidia
          env = __GLX_VENDOR_LIBRARY_NAME,nvidia
          env = __GL_GSYNC_ALLOWED,true
          env = AQ_DRM_DEVICES,/dev/dri/card0
        '';
      };

      wayland = {
        enable = true;
        cursor_theme.size = lib.mkDefault 40;
      };
    };
  };
}
