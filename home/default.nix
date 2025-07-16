{
  flake.homeModules = {
    shell = import ./shell;
    wayland = import ./wayland;
    dashalev = import ./dashalev;
    tmux = import ./tmux;
    fish = import ./fish;
  };
}
