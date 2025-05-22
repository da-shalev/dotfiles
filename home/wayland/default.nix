{ lib, pkgs, config, ... }: {
  options.h.wayland = {
    enable = lib.mkEnableOption "Enables wayland." // { default = false; };

    cursorTheme = {
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
        default = 18;
      };
    };

    iconTheme = {
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

    dconf = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      description = "Key-value settings to apply per user.";
    };
  };

  config = lib.mkIf config.h.wayland.enable {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    environment.variables = {
      GSETTINGS_SCHEMA_DIR =
        "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
    };

    h = {
      xdg = {
        dataFiles = lib.mkMerge [
          (lib.mkIf (config.h.wayland.cursorTheme.package != null) {
            "icons/${config.h.wayland.cursorTheme.name}".source =
              "${config.h.wayland.cursorTheme.package}/share/icons/${config.h.wayland.cursorTheme.name}";
          })
          (lib.mkIf (config.h.wayland.iconTheme.package != null) {
            "icons/${config.h.wayland.iconTheme.name}".source =
              "${config.h.wayland.iconTheme.package}/share/icons/${config.h.wayland.iconTheme.name}";
          })
          (lib.mkIf (config.h.wayland.theme.package != null) {
            "themes/${config.h.wayland.theme.name}".source =
              "${config.h.wayland.theme.package}/share/themes/${config.h.wayland.theme.name}";
          })
        ];

        configFiles = {
          "gtk-3.0/settings.ini".text = lib.concatStringsSep "\n"
            (lib.filter (s: s != "") [
              "[Settings]"
              (lib.optionalString (config.h.wayland.cursorTheme.name != "")
                "gtk-cursor-theme-name=${config.h.wayland.cursorTheme.name}")
              (lib.optionalString true "gtk-cursor-theme-size=${
                  toString config.h.wayland.cursorTheme.size
                }")
              (lib.optionalString (config.h.wayland.iconTheme.package != null)
                "gtk-icon-theme-name=${config.h.wayland.iconTheme.name}")
              (lib.optionalString (config.h.wayland.theme.name != null
                || config.h.wayland.theme.name == "")
                "gtk-theme-name=${config.h.wayland.theme.name}")
            ]);
        };
      };

      shell.variables = {
        MOZ_ENABLE_WAYLAND = 1;
        PROTON_ENABLE_WAYLAND = 1;
        DXVK_HDR = 1;
        QT_QPA_PLATFORM = "wayland";
        NIXOS_OZONE_WL = 1;
        ENABLE_HDR_WSI = 1;
      } // lib.optionalAttrs (config.h.wayland.cursorTheme.package != null) {
        XCURSOR_THEME = config.h.wayland.cursorTheme.name;
        XCURSOR_SIZE = "${toString config.h.wayland.cursorTheme.size}";
      };

      wayland.dconf = lib.mkMerge [
        (lib.optionalAttrs (config.h.wayland.iconTheme.package != null) {
          "/org/gnome/desktop/interface/icon-theme" =
            config.h.wayland.iconTheme.name;
        })
        (lib.optionalAttrs (config.h.wayland.cursorTheme.package != null) {
          "/org/gnome/desktop/interface/cursor-theme" =
            config.h.wayland.cursorTheme.name;
          "/org/gnome/desktop/interface/cursor-size" =
            toString config.h.wayland.cursorTheme.size;
        })
        (lib.optionalAttrs (config.h.wayland.theme.package != null) {
          "/org/gnome/desktop/interface/gtk-theme" =
            config.h.wayland.theme.name;
        })
      ];

      packages = with pkgs; [
        wl-clipboard
        libnotify
        pulsemixer
        xorg.xeyes
        imv
      ];
    };
  };
}
