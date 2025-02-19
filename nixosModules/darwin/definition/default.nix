{ ... }: {
  imports = [ ./nix-settings.nix ./rebuild.nix ];

  security.pam.enableSudoTouchIdAuth = true;
  nix.enable = false;

  system = { stateVersion = 6; };
}
