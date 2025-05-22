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

    xdg.portal = { config.common = { hyprland = [ "hyprland" ]; }; };

    h = {
      packages = with pkgs; [ grim slurp ];
      xdg.configFiles = {
        "hypr/hyprland.conf".text = ''
          exec = ${lib.getExe' pkgs.dbus "dbus-update-activation-environment"} --systemd --all
          ${config.h.hyprland.config}
          ${config.h.hyprland.extraConfig}
        '';
      };
    };
  };
}
