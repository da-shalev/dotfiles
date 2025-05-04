{ config, lib, pkgs, ... }: {
  options.h.tmux = {
    enable = lib.mkEnableOption "Enable tmux." // { default = false; };
    plugins = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
    };
    config = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf config.h.tmux.enable {
    h.packages = with pkgs; [ tmux ];
    environment.etc = let
      plugins = builtins.concatStringsSep "\n" (map (plugin:
        "run-shell ${plugin}/share/tmux-plugins/${plugin.pname}/${plugin.pname}.tmux")
        config.h.tmux.plugins);
    in config.h.profile.addConfigs {
      "tmux/tmux.conf".text = ''
        ${config.h.tmux.config}
        ${plugins}
      '';
    };
  };
}
