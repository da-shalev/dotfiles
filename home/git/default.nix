{ config, lib, ... }: {
  options.h.git = {
    enable = lib.mkEnableOption "Enable git." // { default = true; };
  };

  config = lib.mkIf config.h.git.enable {
    environment.etc = {
      "${config.h.profile.config}/git/ignore".source = ./ignore;
      "${config.h.profile.config}/git/config".source = ./config;
    };
  };
}
