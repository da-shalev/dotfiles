{ pkgs, ... }: {
  config.h = {
    shell = {
      package = pkgs.fish;
      colour = "magenta";
      icon = "🍺";
    };

    dev.enable = true;
    tmux.enable = true;
  };
}
