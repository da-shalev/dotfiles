{ config, lib, pkgs, ... }: {
  options.h.lsd = {
    enable = lib.mkEnableOption "Enable lsd." // { default = true; };
  };

  config = lib.mkIf config.h.lsd.enable {
    home.shellAliases = { s = "${pkgs.lsd}/bin/lsd -lA"; };

    programs.lsd = {
      enable = true;
      settings = {
        classic = false;
        sorting = {
          column = "name";
          reverse = false;
          dir-grouping = "first";
        };
        blocks = [ "permission" "user" "group" "date" "name" ];
        date = "+%b %d";
        dereference = false;
        display = "almost-all";
        ignore-globs = [
          # mac bs
          "**/.DS_Store"
          ".Trash"
          ".cups"
          ".localized"
        ];
        indicators = false;
        layout = "grid";
        size = "short";
        permission = "rwx";
        no-symlink = false;
        total-size = false;
        hyperlink = "never";
        symlink-arrow = "⇒ ";
        header = false;
      };
    };
  };
}
