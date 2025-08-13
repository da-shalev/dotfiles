{ pkgs, lib, self, ... }: {
  imports = [ self.modules.nixos.hyprland self.modules.nixos.mullvad-vpn ];
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

      packages = with pkgs; [ qbittorrent nicotine-plus ];

      shell = {
        package = pkgs.fish;
        colour = "white";
        icon = "👙";
      };

      hyprland = {
        enable = true;
        extraConfig = ''
          monitor=HDMI-A-1,highrr,auto,1
        '';
      };

      wayland = {
        enable = true;
        cursor_theme.size = lib.mkDefault 40;
      };
    };
  };
}
