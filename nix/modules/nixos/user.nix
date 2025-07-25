{
  # user that can be added, for testing and iso's
  flake.modules.nixos.user = { lib, pkgs, self, ... }: {
    imports = [ self.modules.nixos.hyprland ];
    programs.fish.enable = true;

    users.users.nixos = {
      extraGroups = [ "wheel" "video" "networkmanager" ];
      isNormalUser = true;
      shell = pkgs.fish;

      maid = {
        imports = with self.modules.maid; [
          shell
          wayland
          tmux
          fish
          hyprland
          dashalev
        ];

        shell = {
          package = pkgs.fish;
          colour = "green";
          icon = "🍺";
        };

        hyprland = {
          enable = true;
          extraConfig = ''
            monitor=Virtual-1,highres@highrr,auto,1
          '';
        };

        wayland = { enable = true; };
      };
    };
  };
}
