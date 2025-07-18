{ self, lib, ... }: {
  imports = [
    ./hardware.nix
    ./disko
    ./programs
    ./home/dashalev.nix
    self.modules.nixos.disable-sleep
  ];

  environment.persistence."/nix/persist" = { enable = true; };
  networking.firewall = { allowedTCPPorts = [ 4321 8096 8097 ]; };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.systemd.enable = true;
  };

  system.stateVersion = lib.mkForce "24.05";
}
