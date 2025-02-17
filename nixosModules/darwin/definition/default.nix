{ ... }: {
  imports = [ ./nix-settings.nix ];

  security.pam.enableSudoTouchIdAuth = true;
  nix.enable = false;

  system = { stateVersion = 6; };
}
