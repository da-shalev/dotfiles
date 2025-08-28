{ ... }: {
  flake.modules.nixos.hyprland = { lib, config, pkgs, ... }: {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common = { hyprland = [ "hyprland" "gtk" ]; };
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    hardware.graphics.enable = true;

    # WM's don't need these
    xdg = {
      autostart.enable = lib.mkDefault false;
      sounds.enable = lib.mkDefault false;
      menus.enable = lib.mkDefault false;
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
