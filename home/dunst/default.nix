{ pkgs, config, lib, ... }: {
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
          width = "(250, 700)";
          follow = "mouse";
          height = "(0, 250)";
          word_wrap = "yes";
          indicate_hidden = "yes";
          markup = "full";
          # The format of the message.  Possible variables are:
          #   %a  appname
          #   %s  summary
          #   %b  body
          #   %i  iconname (including its path)
          #   %I  iconname (without its path)
          #   %p  progress value if set ([  0%] to [100%]) or nothing
          #   %n  progress value if set without any extra characters
          #   %%  Literal %
          format = "<b>%s</b>\\n%b";
          max_icon_size = "64";
          corner_radius = "24";
          gap_size = "8";
          offset = "8x8";
          show_indicators = "no";
          origin = "top-right";
          padding = "32";
          text_icon_padding = "32";
          horizontal_padding = "32";
          ignore_newline = "yes";
          font = "monospace 24";
          frame_width = 0;
        };

        urgency_normal = {
          background = "#000000";
          foreground = "#fff";
          timeout = 8;
        };

        play_sound = {
          # this rule matches every notification.
          summary = "*";
          script = builtins.toString (pkgs.writeShellScript "alert.sh" ''
            #!/bin/sh
            ${pkgs.pipewire}/bin/pw-play ${./sfx_bookspin.wav}
          '');
        };
      };
    };
  };
}
