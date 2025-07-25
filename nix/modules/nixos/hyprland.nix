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
      withUWSM = true;
      # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      # portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };
  };
}
