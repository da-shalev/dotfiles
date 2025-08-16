{ self, pkgs, lib, ... }: {
  imports = [
    ./hardware.nix
    ./disko
    ./home/dashalev.nix
    ./home/sandbox.nix
    self.modules.nixos.disable-sleep
    self.modules.nixos.mullvad-vpn
  ];

  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-custom ];
  };

  environment.persistence."/nix/persist" = { enable = true; };
  system.stateVersion = lib.mkForce "24.05";
}
