{ config, packages, pkgs, lib, ... }: {
  options.h.dashalev = {
    enable = lib.mkEnableOption
      "Enables consistent personal settings across all user accounts I own."
      // {
        default = false;
      };
  };

  config = lib.mkIf config.h.dashalev.enable (lib.mkMerge [
    (import ./config.nix { inherit packages config pkgs lib; })
    (import ./hyprland { inherit config pkgs lib; })
  ]);
}
