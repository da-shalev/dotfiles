{ config, lib, ... }: {
  options.h.fuzzel = {
    enable = lib.mkEnableOption "Enables fuzzel menu." // { default = false; };
  };

  config = lib.mkIf config.h.fuzzel.enable {
    programs.fuzzel = {
      enable = true;
    };
  };
}
