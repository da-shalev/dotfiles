{ ... }: {
  users.users.test = {
    uid = 1001;
    extraGroups = [ "wheel" "video" "networkmanager" ];
    initialPassword = "boobs";
  };

  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "25.05";
}
