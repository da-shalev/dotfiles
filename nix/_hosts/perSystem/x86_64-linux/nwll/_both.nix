{ ... }: {
  networking.networkmanager = {
    enable = true;
    wifi = { powersave = false; };
  };

  system.stateVersion = "25.05";
}
