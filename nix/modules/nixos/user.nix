{
  # user that can be added, for testing and iso's
  flake.modules.nixos.user = { config, lib, pkgs, self, ... }: {
    options = {
      nixos-user = {
        maid = lib.mkOption {
          type = lib.types.anything;
          default = { };
          description = "Additional maid configuration attributes to append";
        };
      };
    };

    imports = [ self.modules.nixos.hyprland ];

    config = {
      programs.fish.enable = true;
      users.users.nixos = {
        extraGroups = [ "wheel" "video" "networkmanager" ];
        isNormalUser = true;
        shell = pkgs.fish;
        maid = lib.mkMerge [
          {
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
              extraConfig = lib.mkDefault ''
                monitor=Virtual-1,highres@highrr,auto,1
              '';
            };

            wayland = { enable = true; };
          }
          config.nixos-user.maid
        ];
      };
    };
  };
}
