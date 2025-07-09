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

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };

    xdg.portal = { config.common = { hyprland = [ "hyprland" "gtk" ]; }; };

    h = {
      xdg.configFiles = {
        # WARN: testing with this removed, testing if env propagates correctly without
        # exec = ${lib.getExe' pkgs.dbus "dbus-update-activation-environment"} --systemd --all
        "hypr/hyprland.conf".text = ''
          ${config.h.hyprland.config}
          ${config.h.hyprland.extraConfig}
        '';
      };
    };
  };
}
