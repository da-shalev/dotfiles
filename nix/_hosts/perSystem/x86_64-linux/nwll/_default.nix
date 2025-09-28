{ self, pkgs, ... }: {
  imports = [
    ./disko.nix
    ./home/dashalev.nix
    ./home/sandbox.nix
    self.modules.nixos.no-sleep
    self.modules.nixos.hyprland
  ];

  programs = {
    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-custom ];
    };

    fish.enable = true;
  };

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.stable.mullvad-vpn;
  };

  preservation.enable = true;
}
