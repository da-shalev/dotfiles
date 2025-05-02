{
  flake.homeModules = {
    paths = import ./paths.nix;
    foot = import ./foot;
    wayland = import ./wayland;
    hyprland = import ./hyprland;
    # dev = import ./dev;
    # git = import ./git;
    # dunst = import ./dunst;
    # tmux = import ./tmux;
    # fzf = import ./fzf;
    # wmenu = import ./wmenu;
    # fd = import ./fd;
    fish = import ./fish;
    # bash = import ./bash;
    # lsd = import ./lsd;
    # ghostty = import ./ghostty;
    # nixCats = import ./nixCats;
  };
}
