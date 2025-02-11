{ lib, ... }: {
  imports = [ ./nix-settings.nix ];

  services.nix-daemon.enable = true;
  security.pam.enableSudoTouchIdAuth = true;

  system = { stateVersion = 6; };
}
