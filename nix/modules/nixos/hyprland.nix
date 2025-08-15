{ ... }: {
  flake.modules.nixos.hyprland = { lib, config, pkgs, ... }: {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common = { hyprland = [ "hyprland" "gtk" ]; };
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
}
