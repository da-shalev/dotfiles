{ config, ... }: {
  environment.shellAliases = {
    upgrade =
      "darwin-rebuild switch --flake $NIXPKGS_CONFIG#${config.systemGenesis.hostName}";
    bootgrade =
      "darwin-rebuild boot --flake $NIXPKGS_CONFIG#${config.systemGenesis.hostName}";
    update = "nix flake update --flake $NIXPKGS_CONFIG";
    cleanup = "nix-collect-garbage -d && nix store optimise";
  };
}
