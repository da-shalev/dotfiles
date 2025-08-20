{ pkgs, config, ... }: {
  systemd.user.services.autostart-hyprland = {
    enable = true;
    description = "Hyprland compositor for passthrough GPU";
    serviceConfig = {
      ExecStart = "${pkgs.hyprland}/bin/Hyprland";
      Restart = "always";
      # Environment = ''
      #   HOME=${config.users.users.nixos.home}
      #   XDG_RUNTIME_DIR=/run/user/${config.users.users.nixos.uid}
      #   WLR_DRM_DEVICES=/dev/dri/card0
      # '';
    };
    wantedBy = [ "default.target" ];
  };

  systemd.tmpfiles.rules = [ "f /var/lib/systemd/linger/nixos" ];

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
