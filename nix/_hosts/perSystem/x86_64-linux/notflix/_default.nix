{ self, pkgs, ... }: {
  imports = [
    ./disko.nix
    self.modules.nixos.disable-sleep
    self.modules.nixos.tty-only
  ];

  programs.fish.enable = true;

  users.users.dashalev = {
    uid = 1000;
    extraGroups = [ "wheel" "video" "networkmanager" ];
    isNormalUser = true;
    shell = pkgs.fish;
    initialPassword = "boobs";

    maid = {
      imports = with self.modules.maid; [
        shell
        wayland
        tmux
        fish
        hyprland
        dashalev
      ];

      shell = {
        package = pkgs.fish;
        colour = "white";
        icon = "👙";
      };
    };
  };

  environment.persistence."/nix/persist".enable = true;
}
