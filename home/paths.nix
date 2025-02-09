{ lib, pkgs, config, ... }: {
  options.h = {
    homePath = lib.mkOption { type = with lib.types; nonEmptyStr; };
    userName = lib.mkOption { type = with lib.types; nonEmptyStr; };
    dataHome = lib.mkOption { type = with lib.types; nonEmptyStr; };
    configHome = lib.mkOption { type = with lib.types; nonEmptyStr; };
    cacheHome = lib.mkOption { type = with lib.types; nonEmptyStr; };
    shell = {
      package = lib.mkOption { type = lib.types.package; };
      colour = lib.mkOption { type = with lib.types; nonEmptyStr; };
      icon = lib.mkOption { type = with lib.types; nonEmptyStr; };
    };
  };

  config = {
    h = {
      dataHome = "${config.h.homePath}/.local/share";
      configHome = "${config.h.homePath}/.config";
      cacheHome = "${config.h.homePath}/.cache";
    };

    programs = {
      nix-index = { enable = false; };

      # slows down HM
      # however putting mancache at ~ is evil
      man.generateCaches = false;
    };

    xdg = {
      enable = true;
      configHome = "${config.h.configHome}";
      dataHome = "${config.h.dataHome}";
    };

    home = {
      packages = with pkgs; [
        ## NOT MEMES
        asciiquarium-transparent
        nyancat
        cmatrix

        ## SUPER IMPORTANT
        sl
      ];

      shellAliases = {
        tree = "tree -C";
        asciiquarium = "asciiquarium -t";
      };
    };
  };
}
