{ config, lib, ... }: {
  options.h.xdg = {
    enable = lib.mkEnableOption "Enables XDG Dirs." // { default = false; };
  };

  config = lib.mkIf config.h.xdg.enable {
    xdg = {
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
  };
}
