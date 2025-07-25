{ inputs, ... }: {
  # modifications to system wide defaults that make a lot of sense
  flake.modules.nixos.environment = { lib, config, pkgs, ... }: {
    systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ];
    environment = {
      variables = {
        ALSA_CONFIG_UCM2 = "${
            pkgs.alsa-ucm-conf.overrideAttrs
            (old: { src = inputs.alsa-ucm-conf; })
          }/share/alsa/ucm2";
      };

      systemPackages = with pkgs;
        [
          (lib.mkIf
            (builtins.elem "nvidia" config.services.xserver.videoDrivers)
            nvitop)
        ];

      persistence."/nix/persist" = {
        enable = lib.mkDefault false;
        hideMounts = true;
        directories =
          [ "/var/lib/nixos" "/var/log" "/var/lib/systemd/coredump" "/tmp" ]
          ++ lib.optionals config.networking.networkmanager.enable [
            "/var/lib/NetworkManager/"
            "/etc/NetworkManager/"
          ] ++ lib.optionals config.hardware.bluetooth.enable
          [ "/var/lib/bluetooth/" ];
      };

      sessionVariables = { NIXPKGS_ALLOW_UNFREE = "1"; };
      localBinInPath = lib.mkDefault true;
    };

    hardware.bluetooth.settings.General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };
}
