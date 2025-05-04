{ config, lib, pkgs, ... }: {
  options.h.dashalev = {
    enable = lib.mkEnableOption
      "Enables consistent personal preferences across all user accounts I own."
      // {
        default = false;
      };
  };

  config.h = lib.mkIf config.h.foot.enable {
    shell.aliases = { s = "${lib.getExe pkgs.lsd} -lA"; };
  };
}
