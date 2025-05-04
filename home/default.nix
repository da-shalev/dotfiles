{
  flake.homeModules = {
    paths = import ./paths.nix;
    foot = import ./foot;
    wayland = import ./wayland;
    hyprland = import ./hyprland;
    dashalev = import ./dashalev;
    git = import ./git;
    tmux = import ./tmux;
    # fzf = import ./fzf;
    # wmenu = import ./wmenu;
    # fd = import ./fd;
    fish = import ./fish;
    mnw = import ./mnw;
    lsd = import ./lsd;
    ghostty = import ./ghostty;
    # nixCats = import ./nixCats;
  };
}
