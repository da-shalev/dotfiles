{ ... }: {
  imports = [ ./nix-settings.nix ./rebuild.nix ];

  security.pam.services.sudo_local.touchIdAuth = true;
  nix.enable = false;

  system = { stateVersion = 6; };
}
