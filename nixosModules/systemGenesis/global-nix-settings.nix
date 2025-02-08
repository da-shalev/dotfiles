{ pkgs, lib, inputs, ... }: {
  nixpkgs = { config.allowUnfree = lib.mkForce true; };

  nix = {
    package = pkgs.nixVersions.latest;
    registry.nixpkgs.flake = inputs.nixpkgs;
    channel.enable = false;
    settings = {
      nix-path = "nixpkgs=flake:nixpkgs";
      builders-use-substitutes = true;
      http-connections = 128;
      max-substitution-jobs = 128;
      download-buffer-size = 134217728;
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
