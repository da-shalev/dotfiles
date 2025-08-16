{ self, lib, ... }: {
  imports = [
    ./hardware.nix
    self.modules.nixos.disable-sleep
  ];

  system.stateVersion = lib.mkForce "25.05";
}
