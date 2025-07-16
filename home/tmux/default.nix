{ config, lib, pkgs, ... }: {
  options.tmux = {
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

  config = lib.mkIf config.tmux.enable {
    packages = with pkgs; [ tmux ];
    file.xdg_config = let
      plugins = builtins.concatStringsSep "\n" (map (plugin:
        "run-shell ${plugin}/share/tmux-plugins/${plugin.pname}/${plugin.pname}.tmux")
        config.tmux.plugins);
    in {
      "tmux/tmux.conf".text = ''
        ${config.tmux.config}
        ${plugins}
      '';
    };
  };
}
