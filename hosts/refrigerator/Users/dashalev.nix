{ pkgs, ... }: {
  config.h = {
    shell = {
      package = pkgs.fish;
      colour = "magenta";
      icon = "🍺";
    };

    dashalev.enable = true;
  };
}
