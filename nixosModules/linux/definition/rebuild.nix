{ config, ... }: {
  environment.shellAliases = if config.programs.nh.enable then {
    upgrade = "nh os switch $NIXPKGS_CONFIG";
    bootgrade = "nh os boot $NIXPKGS_CONFIG";
    update = "nix flake update --flake $NIXPKGS_CONFIG";
    cleanup = "nh clean all && nix store optimise";
  } else {
    upgrade =
      "sudo nixos-rebuild switch --flake $NIXPKGS_CONFIG#${config.systemGenesis.hostName}";
    bootgrade =
      "sudo nixos-rebuild boot --flake $NIXPKGS_CONFIG#${config.systemGenesis.hostName}";
    update = "nix flake update --flake $NIXPKGS_CONFIG";
    cleanup = "nix-collect-garbage -d && nix store optimise";
  };
}
