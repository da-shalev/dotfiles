{ inputs, ... }: {
  # modifications to system wide defaults that make a lot of sense
  flake.modules.nixos.environment = { lib, config, pkgs, ... }: {
    systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ];

    environment = {
      variables = {
        ALSA_CONFIG_UCM2 = "${
            pkgs.stable.alsa-ucm-conf.overrideAttrs
            (old: { src = inputs.alsa-ucm-conf; })
          }/share/alsa/ucm2";
      };

      systemPackages = with pkgs;
        [
          (lib.mkIf
            (builtins.elem "nvidia" config.services.xserver.videoDrivers)
            nvitop)
        ];

      sessionVariables = { NIXPKGS_ALLOW_UNFREE = "1"; };
      localBinInPath = lib.mkDefault true;
    };

    preservation.preserveAt."/nix/persist" = {
      commonMountOptions = [ "x-gvfs-hide" "x-gdu.hide" ];
      directories = [
        "/var/log"
        "/var/lib/systemd/coredump"
        {
          directory = "/tmp";
          mode = "1777";
        }
      ] ++ lib.optionals config.networking.networkmanager.enable [
        "/var/lib/NetworkManager/"
        "/etc/NetworkManager/"
      ] ++ lib.optionals config.hardware.bluetooth.enable
        [ "/var/lib/bluetooth/" ];
      files = [
        {
          file = "/var/lib/systemd/random-seed";
          how = "symlink";
          inInitrd = true;
          configureParent = true;
        }
        {
          file = "/etc/machine-id";
          inInitrd = true;
          how = "symlink";
          configureParent = true;
        }
      ];
    };

    systemd = {
      suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
    };

    hardware.bluetooth.settings.General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };
}
