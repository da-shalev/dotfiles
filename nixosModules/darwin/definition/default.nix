{ lib, config, ... }: {
  imports = [ ./nix-settings.nix ];

  services.nix-daemon.enable = true;
  security.pam.enableSudoTouchIdAuth = true;

  environment.shellAliases = {
    upgrade =
      "darwin-rebuild switch --flake ~/${config.genesis.configDir}#${config.genesis.hostName}";
    bootgrade =
      "darwin-rebuild build --flake ~/${config.genesis.configDir}#${config.genesis.hostName}";
    update = "nix flake update --flake ~/${config.genesis.configDir}";
  };

  system = { stateVersion = lib.mkForce 4; };
}
