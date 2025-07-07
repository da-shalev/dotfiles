{ inputs, ... }: {
  _module.args = {
    linuxUser = userName: homeConfiguration: {
      imports = with inputs.self.home;
        [
          { h = { userName = "${userName}"; }; }
          paths
          tmux
          wmenu
          hyprland
          wayland
          fish
          rebuild
          dashalev
        ] ++ homeConfiguration;
    };
  };
}
