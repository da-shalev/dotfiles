{ config, lib, ... }: {
  options.h.dunst = {
    enable = lib.mkEnableOption "Enables Dunst, a notification daemon." // {
      default = false;
    };
  };

  config = lib.mkIf config.h.dunst.enable {
    services.dunst = {
      enable = true;

      iconTheme = lib.mkIf config.h.wayland.enable {
        inherit (config.h.wayland.iconTheme) name;
        inherit (config.h.wayland.iconTheme) package;
        size = "32x32";
      };

      settings = {
        global = {
          width = 550;
          height = 250;
          origin = "top-right";
          offset = "00x00";
          font = "monospace 24";
          frame_width = 0;
        };

        urgency_normal = {
          background = "#000";
          foreground = "#fff";
          timeout = 8;
        };
      };
    };
  };
}
