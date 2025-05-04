{ config, lib, pkgs, ... }: {
  options.h.foot = {
    enable = lib.mkEnableOption "Enables foot terminal." // {
      default = false;
    };
    config = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf config.h.foot.enable {
    h.packages = with pkgs; [ foot ];
    environment.etc = config.h.profile.addConfigs {
      "foot/foot.ini".text = config.h.foot.config;
    };
  };
}
