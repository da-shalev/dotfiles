{ config, pkgs, ... }:
let domain = "thefiredman.xyz";
in {
  imports = [
    (import ./jellyfin.nix { inherit config domain pkgs; })
    (import ./caddy.nix { inherit config domain pkgs; })
  ];
}
