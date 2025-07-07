{ inputs, lib, pkgs, config, ... }:
let cfgLocation = "/etc/nixos";
in {
  imports = [
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
    ./genesis.nix
  ];

  environment = {
    sessionVariables = { NIXPKGS_ALLOW_UNFREE = "1"; };
    variables.NIXPKGS_CONFIG = cfgLocation;
  };

  time.timeZone = lib.mkDefault "Canada/Eastern";

  programs = {
    direnv = {
      enable = true;
      silent = true;
    };

    command-not-found.enable = lib.mkForce false;
    fuse.userAllowOther = true;
    git = { enable = true; };
  };

  environment = {
    # override all default packages from nix
    defaultPackages = [ ];
    systemPackages = with pkgs; [ usbutils pciutils file libva-utils ];
    persistence."/nix/persist" = {
      hideMounts = true;
      directories = [
        "/var/lib/nixos"
        "/var/log"
        "/var/lib/systemd/coredump"
        cfgLocation
        "/tmp"
      ];
    };
  };

  users.mutableUsers = lib.mkDefault false;
  security = { rtkit = { inherit (config.services.pipewire) enable; }; };

  services = {
    fstrim.enable = true;
    pulseaudio.enable = false;
    udisks2.enable = true;
    dbus.implementation = "broker";
    openssh.enable = true;
    rsyncd.enable = true;
    pipewire = {
      inherit (config.hardware.graphics) enable;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
    };
  };
}
