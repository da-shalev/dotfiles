{ config, lib, ... }: {
  options.h.git = {
    enable = lib.mkEnableOption "Enable git." // { default = false; };

    config = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };

    ignore = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf config.h.git.enable {
    environment.etc = config.h.profile.addConfigs {
      "git/ignore".text = config.h.git.ignore;
      "git/config".text = config.h.git.config;
    };
  };
}
