{ lib, pkgs, config, ... }: {
  options.h = {
    userName = lib.mkOption { type = with lib.types; nonEmptyStr; };
    dataHome = lib.mkOption { type = with lib.types; nonEmptyStr; };
    stateHome = lib.mkOption { type = with lib.types; nonEmptyStr; };
    configHome = lib.mkOption { type = with lib.types; nonEmptyStr; };
    cacheHome = lib.mkOption { type = with lib.types; nonEmptyStr; };
    shell = {
      package = lib.mkOption { type = lib.types.package; };
      colour = lib.mkOption { type = with lib.types; nonEmptyStr; };
      icon = lib.mkOption { type = with lib.types; nonEmptyStr; };
    };
  };

  config = {
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
      cacheHome = "${config.h.cacheHome}";
      stateHome = "${config.h.stateHome}";

      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = "${config.home.homeDirectory}/";
        documents = "${config.home.homeDirectory}/dox";
        download = "${config.home.homeDirectory}/dow";
        videos = "${config.home.homeDirectory}/vid";
        music = "${config.home.homeDirectory}/";
        pictures = "${config.home.homeDirectory}/pix";
        publicShare = "${config.home.homeDirectory}/media";
        templates = "${config.home.homeDirectory}/";
      };
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
