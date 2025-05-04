{ lib, pkgs, config, ... }: {
  options.h.wayland = {
    enable = lib.mkEnableOption "Enables wayland." // { default = false; };
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
        type = lib.types.nullOr lib.types.package;
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

    # qt = {
    #   name = lib.mkOption {
    #     type = with lib.types; nonEmptyStr;
    #     default = "adwaita-dark";
    #   };
    #
    #   package = lib.mkOption {
    #     type = lib.types.package;
    #     default = pkgs.adwaita-qt;
    #   };
    # };
  };

  config = lib.mkIf config.h.wayland.enable {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    environment.etc = lib.mkIf (config.h.wayland.cursorTheme.package != null) {
      "${config.h.profile.data}/icons/${config.h.wayland.cursorTheme.name}".source =
        "${config.h.wayland.cursorTheme.package}/share/icons/${config.h.wayland.cursorTheme.name}";
    };

    h = {
      shell.variables = {
        MOZ_ENABLE_WAYLAND = "1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_QPA_PLATFORM = "wayland";
        XCURSOR_SIZE = "${toString config.h.wayland.cursorTheme.size}";
        GTK_THEME = config.h.wayland.theme.name;
        NIXOS_OZONE_WL = 1;
        ENABLE_HDR_WSI = 1;
      } // lib.optionalAttrs (config.h.wayland.cursorTheme.package != null) {
        XCURSOR_THEME = config.h.wayland.cursorTheme.name;
      };

      packages = with pkgs; [
        wl-clipboard
        pwvucontrol_git
        nautilus
        libnotify
        pulsemixer
        # dconf-editor
        xorg.xeyes
        imv
      ];
    };
  };

  # dconf.settings = {
  #   "org/gnome/desktop/interface" = {
  #     color-scheme = "prefer-dark";
  #     cursor-theme = config.h.wayland.cursorTheme.name;
  #   };
  #   "org/gnome/desktop/wm/preferences" = { button-layout = ""; };
  # };
}
