{ config, lib, ... }: {
  options.h.fzf = {
    enable = lib.mkEnableOption "Enable fzf." // { default = true; };
  };

  config = lib.mkIf config.h.fzf.enable {
    programs.fzf = {
      enable = true;
      defaultOptions = [ "--height 100%" "--layout=reverse" "--exact" ];
    };
  };
}
