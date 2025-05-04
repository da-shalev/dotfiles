{ config, inputs, lib, pkgs, ... }: {
  options.h.hyprland = {
    enable = lib.mkEnableOption "Enables hyprland WM." // { default = false; };
    mod = lib.mkOption {
      type = lib.types.str;
      default = "SUPER";
    };
    config = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf config.h.hyprland.enable {
    xdg.portal.config.hyprland.default = [ "hyprland" "gtk" ];

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };

    environment.etc = config.h.profile.addConfigs {
      "hypr/hyprland.conf".text = ''
        ${config.h.hyprland.config}
        ${config.h.hyprland.extraConfig}
      '';
    };
  };
}
