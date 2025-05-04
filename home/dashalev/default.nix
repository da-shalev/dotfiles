{ config, pkgs, lib, ... }: {
  options.h.dashalev = {
    enable = lib.mkEnableOption
      "Enables consistent personal settings across all user accounts I own."
      // {
        default = false;
      };
  };

  config = (lib.mkMerge [
    (import ./config.nix { inherit config pkgs lib; })
    (import ./hyprland { inherit config pkgs lib; })
  ]);
}
