{ config, lib, ... }: {
  environment.shellAliases = lib.mkIf config.programs.nh.enable {
    upgrade =
      "nh os switch $NIXPKGS_CONFIG";
    bootgrade =
      "nh os boot $NIXPKGS_CONFIG";
    update = "nix flake update --flake ~/$NIXPKGS_CONFIG";
    cleanup = "nh clean all && nix store optimise";
  };
}
