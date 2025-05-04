{
  flake.homeModules = {
    paths = import ./paths.nix;
    foot = import ./foot;
    wayland = import ./wayland;
    hyprland = import ./hyprland;
    dashalev = import ./dashalev;
    git = import ./git;
    tmux = import ./tmux;
    # wmenu = import ./wmenu;
    fish = import ./fish;
    rebuild = import ./rebuild;
    lsd = import ./lsd;
  };
}
