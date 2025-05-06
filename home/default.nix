{
  flake.homeModules = {
    paths = import ./paths.nix;
    wayland = import ./wayland;
    hyprland = import ./hyprland;
    dashalev = import ./dashalev;
    tmux = import ./tmux;
    wmenu = import ./wmenu;
    fish = import ./fish;
    rebuild = import ./rebuild;
    steam = import ./steam;
  };
}
