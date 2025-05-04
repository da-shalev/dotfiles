{ config, lib, ... }: {
  options.h.mnw = {
    enable = lib.mkEnableOption "Enable nvim" // { default = true; };
  };

  config = lib.mkIf config.h.mnw.enable {
  };
}
