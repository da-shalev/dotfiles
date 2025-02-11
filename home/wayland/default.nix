{ lib, pkgs, config, ... }: {
  options.h.wayland = {
    enable = lib.mkEnableOption "Enables Wayland." // { default = false; };
    iconTheme = {
      name = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "Adwaita";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.adwaita-icon-theme;
      };
    };

    cursorTheme = {
      name = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = "Adwaita";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.adwaita-icon-theme;
      };
      size = lib.mkOption {
        type = with lib.types; number;
        default = 18;
      };
    };

    theme = {
      name = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = "adw-gtk3-dark";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.adw-gtk3;
      };
    };

    qt = {
      name = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = "adwaita-dark";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.adwaita-qt;
      };
    };
  };

  config = lib.mkIf config.h.wayland.enable {
    gtk = {
      enable = true;
      theme = {
        inherit (config.h.wayland.theme) name;
        inherit (config.h.wayland.theme) package;
      };

      iconTheme = {
        inherit (config.h.wayland.iconTheme) name;
        inherit (config.h.wayland.iconTheme) package;
      };

      cursorTheme = {
        inherit (config.h.wayland.cursorTheme) name;
        inherit (config.h.wayland.cursorTheme) package;
        inherit (config.h.wayland.cursorTheme) size;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style = {
        inherit (config.h.wayland.qt) package;
        inherit (config.h.wayland.qt) name;
      };
    };

    home = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = "1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_QPA_PLATFORM = "wayland";
        XCURSOR_THEME = config.h.wayland.cursorTheme.name;
        XCURSOR_SIZE = "${toString config.h.wayland.cursorTheme.size}";
        GTK_THEME = config.h.wayland.theme.name;
      };

      packages = with pkgs; [
        wl-clipboard
        pwvucontrol
        nautilus
        libnotify
        pulsemixer
        dconf-editor
        xorg.xeyes
        imv
      ];

      pointerCursor = {
        gtk.enable = true;
        inherit (config.h.wayland.cursorTheme) name;
        inherit (config.h.wayland.cursorTheme) package;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        cursor-theme = config.h.wayland.cursorTheme.name;
      };
      "org/gnome/desktop/wm/preferences" = { button-layout = ""; };
    };
  };
}
