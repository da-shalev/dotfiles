{ config, lib, ... }: {
  options.h.ghostty = {
    enable = lib.mkEnableOption "Enable ghostty configuration." // {
      default = false;
    };
  };

  config = lib.mkIf config.h.ghostty.enable {
    environment.etc = {
      "${config.h.xdg.path}/ghostty/config".text = ''
        theme = GruvboxDarkHard
        font-family = CaskaydiaCove Nerd Font Mono
        font-size = 32
        shell-integration-features = no-cursor,sudo,no-title
        cursor-style = block
        window-padding-balance = true
        window-colorspace = "display-p3"
        background = 000000
        cursor-style-blink = false
        # window-decoration = false
        window-inherit-font-size = true
        confirm-close-surface = false
      '';
    };
  };
}
