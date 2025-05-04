{ config, lib, pkgs, ... }: {
  options.h.tmux = {
    enable = lib.mkEnableOption "Enable tmux." // { default = true; };
    plugins = lib.mkOption {
      type = with lib.types; listOf package;
      default = with pkgs.tmuxPlugins; [ yank vim-tmux-navigator ];
    };
  };

  config = lib.mkIf config.h.tmux.enable {
    h.extraPackages = with pkgs; [ tmux tmux-sessionizer ];
    environment.etc = let
      plugins = builtins.concatStringsSep "\n" (map (plugin:
        "run-shell ${plugin}/share/tmux-plugins/${plugin.pname}/${plugin.pname}.tmux")
        config.h.tmux.plugins);
    in {
      "${config.h.profile.config}/tms/config.toml".text = ''
        excluded_dirs = [".direnv"]

        [[search_dirs]]
        path = "${config.systemGenesis.config}/"
        depth = 5

        [[search_dirs]]
        path = "${config.h.path}/media/"
        depth = 20
      '';
      "${config.h.profile.config}/tmux/tmux.conf".text = ''
        ${builtins.readFile ./tmux.conf}
        ${plugins}
      '';
    };
  };
}
