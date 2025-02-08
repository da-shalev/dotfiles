{ config, lib, ... }: {
  options.h.fzf = {
    enable = lib.mkEnableOption "Enable fzf." // { default = true; };
  };

  config = lib.mkIf config.h.fzf.enable {
    programs.fzf = {
      enable = true;
      tmux.enableShellIntegration = false;
      enableFishIntegration = false;
      enableBashIntegration = false;
      enableZshIntegration = false;
      defaultOptions = [ "--height 100%" "--layout=reverse" "--exact" ];
    };
  };
}
