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
      imports = with self.modules.maid; [
        shell
        wayland
        tmux
        fish
        hyprland
        dashalev
      ];

      packages = with pkgs; [
        krita
        chromium
        zathura
        signal-desktop-bin
        telegram-desktop
        mangohud
        vulkan-hdr-layer-kwin6
        prismlauncher

        qbittorrent
        nicotine-plus
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
        '';
      };

      wayland = {
        enable = true;
        cursor_theme.size = lib.mkDefault 40;
      };
    };
  };
}
