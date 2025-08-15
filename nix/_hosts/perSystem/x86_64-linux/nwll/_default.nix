{ self, lib, ... }: {
  imports = [
    ./hardware.nix
    ./disko
    ./steam.nix
    ./home/dashalev.nix
    ./home/sandbox.nix
    self.modules.nixos.disable-sleep
    self.modules.nixos.mullvad-vpn
  ];

  environment.persistence."/nix/persist" = { enable = true; };
  system.stateVersion = lib.mkForce "24.05";
}
