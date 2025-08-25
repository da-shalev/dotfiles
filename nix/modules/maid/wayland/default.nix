{
  flake.modules.maid.wayland = { lib, pkgs, config, ... }: {
    options.wayland = {
      enable = lib.mkEnableOption "Enables wayland." // { default = false; };

      cursor_theme = {
        name = lib.mkOption {
          type = with lib.types; nonEmptyStr;
          default = "Adwaita";
        };
        package = lib.mkOption {
          type = lib.types.nullOr lib.types.package;
          default = pkgs.adwaita-icon-theme;
        };
        size = lib.mkOption {
          type = with lib.types; number;
          default = 24;
        };
      };

      icon_theme = {
        name = lib.mkOption {
          type = lib.types.nonEmptyStr;
          default = "Adwaita";
        };
        package = lib.mkOption {
          type = lib.types.nullOr lib.types.package;
          default = pkgs.adwaita-icon-theme;
        };
      };

      theme = {
        name = lib.mkOption {
          type = with lib.types; nonEmptyStr;
          default = "adw-gtk3-dark";
        };

        package = lib.mkOption {
          type = lib.types.nullOr lib.types.package;
          default = pkgs.adw-gtk3;
        };
      };
    };

    config = lib.mkIf config.wayland.enable {
      systemd.tmpfiles.dynamicRules = [
        (lib.mkIf (config.wayland.cursor_theme.package != null)
          "L+ {{xdg_data_home}}/icons/${config.wayland.cursor_theme.name} - - - - ${config.wayland.cursor_theme.package}/share/icons/${config.wayland.cursor_theme.name}")
        (lib.mkIf (config.wayland.icon_theme.package != null)
          "L+ {{xdg_data_home}}/icons/${config.wayland.icon_theme.name} - - - - ${config.wayland.icon_theme.package}/share/icons/${config.wayland.icon_theme.name}")
        (lib.mkIf (config.wayland.theme.package != null)
          "L+ {{xdg_data_home}}/themes/${config.wayland.theme.name} - - - - ${config.wayland.theme.package}/share/themes/${config.wayland.theme.name}")
      ];

      file = {
        xdg_config = {
          "gtk-3.0/settings.ini".text = lib.concatStringsSep "\n"
            (lib.filter (s: s != "") [
              "[Settings]"
              (lib.optionalString (config.wayland.cursor_theme.name != "")
                "gtk-cursor-theme-name=${config.wayland.cursor_theme.name}")
              (lib.optionalString true "gtk-cursor-theme-size=${
                  toString config.wayland.cursor_theme.size
                }")
              (lib.optionalString (config.wayland.icon_theme.package != null)
                "gtk-icon-theme-name=${config.wayland.icon_theme.name}")
              (lib.optionalString (config.wayland.theme.name != null
                || config.wayland.theme.name == "")
                "gtk-theme-name=${config.wayland.theme.name}")
            ]);
        };
      };

      shell.variables = {
        MOZ_ENABLE_WAYLAND = 1;
        PROTON_ENABLE_WAYLAND = 1;
        DXVK_HDR = 1;
        NIXOS_OZONE_WL = 1;
        ENABLE_HDR_WSI = 1;
      } // lib.optionalAttrs (config.wayland.cursor_theme.package != null) {
        XCURSOR_THEME = config.wayland.cursor_theme.name;
        XCURSOR_SIZE = "${toString config.wayland.cursor_theme.size}";
      };

      dconf.settings = lib.mkMerge [
        (lib.optionalAttrs (config.wayland.icon_theme.package != null) {
          "/org/gnome/desktop/interface/icon-theme" =
            config.wayland.icon_theme.name;
        })
        (lib.optionalAttrs (config.wayland.cursor_theme.package != null) {
          "/org/gnome/desktop/interface/cursor-theme" =
            config.wayland.cursor_theme.name;
          "/org/gnome/desktop/interface/cursor-size" =
            config.wayland.cursor_theme.size;
        })
        (lib.optionalAttrs (config.wayland.theme.package != null) {
          "/org/gnome/desktop/interface/gtk-theme" = config.wayland.theme.name;
        })
      ];

      packages = with pkgs; [
        wl-clipboard
        libnotify
        xorg.xeyes
        imv
        libxcvt
      ];
    };
  };
}
