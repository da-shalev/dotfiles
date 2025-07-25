{ pkgs, lib, self, ... }: {
  imports = [ self.modules.nixos.hyprland ];
  programs.fish.enable = true;

  users.users.dashalev = {
    uid = 1000;
    extraGroups = [ "wheel" "video" "networkmanager" "steam" ];
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
        # aseprite
        # blender
        # krita
        # gimp3
        zathura
        signal-desktop-bin
        mangohud
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
        '';
      };

      wayland = {
        enable = true;
        cursor_theme.size = lib.mkDefault 40;
      };
    };
  };
}
