{
  # user that can be added, for testing and iso's
  flake.modules.nixos.user =
    {
      config,
      lib,
      pkgs,
      self,
      ...
    }:
    {
      imports = [ self.modules.nixos.hyprland ];

      config = {
        programs.fish.enable = true;
        users.users.nixos = {
          extraGroups = [
            "wheel"
            "video"
            "networkmanager"
          ];
          isNormalUser = true;
          shell = pkgs.fish;
          maid = {
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

            wayland = {
              enable = true;
            };
          };
        };
      };
    };
}
