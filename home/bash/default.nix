{ config, lib, ... }: {
  options.h.bash = {
    enable = lib.mkEnableOption "Enables the bash shell." // {
      default = true;
    };
  };

  config = lib.mkIf config.h.bash.enable {
    programs.bash = {
      enable = true;
      historyFile = "~/.cache";
    };
  };
}
