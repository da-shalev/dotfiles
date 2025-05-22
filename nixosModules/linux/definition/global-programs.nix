{ config, pkgs, lib, ... }: {
  config = lib.mkMerge [
    (lib.mkIf (config.systemGenesis.rootIsTmpfs) {
      environment.persistence."/nix/persist" = {
        enable = true;
        hideMounts = true;
        directories = [
          "/var/lib/nixos"
          "/var/log"
          "/var/lib/systemd/coredump"
          "/etc/nixos"
          "/tmp"
        ];
      };
    })
    {
      time.timeZone = lib.mkDefault "Canada/Eastern";

      environment = {
        # override all default packages from nix
        defaultPackages = [ ];
        systemPackages = with pkgs; [ usbutils pciutils file libva-utils ];
      };

      networking = {
        firewall.enable = lib.mkDefault false;
        useDHCP = lib.mkDefault true;
        # hostId = lib.mkDefault (builtins.substring 0 8
        #   (builtins.hashString "md5" config.networking.hostName));
      };

      users.mutableUsers = lib.mkDefault false;

      security = { rtkit = { inherit (config.services.pipewire) enable; }; };

      services = {
        fstrim.enable = lib.mkForce true;
        pulseaudio.enable = lib.mkForce false;
        udisks2.enable = lib.mkForce true;
        dbus.implementation = lib.mkForce "broker";
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

      programs = {
        command-not-found.enable = lib.mkForce false;
        fuse.userAllowOther = true;
        git = { enable = true; };
      };

      documentation = {
        enable = lib.mkForce true;
        man.enable = lib.mkForce true;
        doc.enable = lib.mkForce false;
        nixos.enable = lib.mkForce false;
        info.enable = lib.mkForce false;
      };
    }
  ];
}
