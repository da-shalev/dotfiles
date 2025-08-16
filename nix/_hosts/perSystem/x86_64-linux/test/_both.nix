{ ... }: {
  networking.networkmanager = {
    enable = true;
    wifi = { powersave = false; };
  };

  services = { qemuGuest.enable = true; };

  system.stateVersion = "25.05";
}
