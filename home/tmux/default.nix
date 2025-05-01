{ config, lib, pkgs, ... }: {
  options.h.tmux = {
    enable = lib.mkEnableOption "Enable tmux." // { default = true; };
  };

  config = lib.mkIf config.h.tmux.enable {
    home.packages = with pkgs; [ tmux-sessionizer ];
    xdg.configFile = {
      "tms/config.toml".text = ''
        excluded_dirs = [".direnv"]

        [[search_dirs]]
        path = "${config.h.configHome}/"
        depth = 5

        [[search_dirs]]
        path = "${config.home.homeDirectory}/media/"
        depth = 20
      '';
    };

    programs.tmux = {
      enable = true;
      keyMode = "vi";
      mouse = true;
      prefix = "C-b";
      sensibleOnTop = false;
      baseIndex = 1;
      disableConfirmationPrompt = true;
      customPaneNavigationAndResize = true;
      extraConfig = ''
        set -g @yank_with_mouse on

        set-option -g renumber-windows on
        set-option -sg escape-time 10
        set-option -g focus-events on
        set-option -gq allow-passthrough on

        set -g default-terminal "tmux-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"

        set-option -g pane-active-border-style "fg=magenta"
        set-option -g pane-border-style "fg=default"
        set-option -g status-style "bg=default,fg=brightwhite"
        set-option -g status-right "  ⌚ %b %d  #( [ $(date +%H) -lt 12 ] && echo 🌙 || echo ☀️ ) %H:%M  #[bg=green,fg=brightwhite]#{?client_prefix,#[bg=yellow],}  #S  #[bg=cyan,fg=brightwhite]  #H  "
        set-option -g status-left ""
        set-window-option -g window-status-separator ""
        set-window-option -g window-status-current-format "#[fg=brightwhite,bg=magenta]  #I #W  "
        set-window-option -g window-status-format "#[fg=brightwhite]#[bg=default]  #I #W  "
        # this is retarded
        set -g status-right-length 120

        bind-key -T copy-mode-vi 'C-h' select-pane -L
        bind-key -T copy-mode-vi 'C-j' select-pane -D
        bind-key -T copy-mode-vi 'C-k' select-pane -U
        bind-key -T copy-mode-vi 'C-l' select-pane -R

        bind s display-popup -E "tms switch"
        bind S display-popup -E "tms"

        # refresh every x seconds
        set-option -g status-interval 10
      '';
      plugins = with pkgs.tmuxPlugins; [ yank vim-tmux-navigator ];
    };
  };
}
