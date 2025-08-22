{ pkgs, ... }: {
  # systemd.user.services.autostart-hyprland = {
  #   enable = true;
  #   description = "Hyprland compositor for passthrough GPU";
  #   serviceConfig = {
  #     ExecStart = "${pkgs.hyprland}/bin/Hyprland";
  #     Restart = "always";
  #   };
  #   wantedBy = [ "default.target" ];
  # };
  #
  # systemd.tmpfiles.rules = [ "f /var/lib/systemd/linger/nixos" ];

  nixos-user = {
    maid = {
      packages = with pkgs; [ zathura ];
      hyprland = {
        enable = true;
        mod = "ALT";
      };
    };
  };
}
