{
  flake.homeModules = {
    paths = import ./paths.nix;
    foot = import ./foot;
    dev = import ./dev;
    git = import ./git;
    tmux = import ./tmux;
    fzf = import ./fzf;
    fd = import ./fd;
    fish = import ./fish;
    bash = import ./bash;
    lsd = import ./lsd;
    river = import ./river;
    ghostty = import ./ghostty;
    wayland = import ./wayland;
    xdg = import ./xdg;
    scripts = import ./scripts;
    nixCats = import ./nixCats;
  };
}
