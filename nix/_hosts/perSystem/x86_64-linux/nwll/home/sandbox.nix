{ pkgs, lib, self, ... }: {
  imports = [ self.modules.nixos.hyprland ];
  programs.fish.enable = true;

  users.users.sandbox = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" "dotfiles" ];
    shell = pkgs.fish;
    initialPassword = "boobs";

    maid = {
      imports = with self.modules.maid; [
        shell
        tmux
        fish
        dashalev
        hyprland
        wayland
      ];

      packages = with pkgs; [ qbittorrent nicotine-plus heroic ];

      shell = {
        package = pkgs.fish;
        colour = "cyan";
        icon = "📦";
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
