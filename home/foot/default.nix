{ config, lib, ... }: {
  options.h.foot = {
    enable = lib.mkEnableOption "Enables foot terminal." // {
      default = false;
    };
  };

  config = lib.mkIf config.h.foot.enable {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          font = "monospace:size=28, Apple Color Emoji:size=28";
          term = "xterm-256color";
          dpi-aware = "no";
          pad = "0x0";
        };

        mouse = { hide-when-typing = "no"; };

        colors = {
          # alpha = "0.95";
          alpha = "1";
          background = "000000";
          foreground = "ebdbb2";
          regular0 = "282828";
          regular1 = "cc241d";
          regular2 = "98971a";
          regular3 = "d79921";
          regular4 = "458588";
          regular5 = "b16286";
          regular6 = "689d6a";
          regular7 = "a89984";
          bright0 = "928374";
          bright1 = "fb4934";
          bright2 = "b8bb26";
          bright3 = "fabd2f";
          bright4 = "83a598";
          bright5 = "d3869b";
          bright6 = "8ec07c";
          bright7 = "ebdbb2";
        };
      };
    };
  };
}
