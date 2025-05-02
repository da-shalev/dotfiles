{ ... }: {
  users.users.testuser = {
    uid = 1001;
  };

  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "25.05";
}
