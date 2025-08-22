{ ... }: {
  networking.networkmanager = {
    enable = true;
    wifi = { powersave = false; };
  };

  imports = [
    ./hardware.nix
  ];


  services = { qemuGuest.enable = true; };
  system.stateVersion = "25.05";
}
