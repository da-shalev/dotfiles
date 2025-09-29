{ self, pkgs, ... }: {
  imports = [
    ./disko.nix
    self.modules.nixos.no-sleep
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
      shell = {
        package = pkgs.fish;
        colour = "white";
        icon = "👙";
      };
    };
  };

  preservation.enable = true;
}
