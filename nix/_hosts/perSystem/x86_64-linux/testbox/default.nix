{
  self,
  pkgs,
  ...
}:
{
  imports = [
    ./_disko.nix
    self.modules.nixos.no-sleep
    self.modules.nixos.tty-only
  ];

  programs.fish.enable = true;

  preservation = {
    enable = true;
  };

  users.users.dashalev = {
    uid = 1000;
    extraGroups = [
      "wheel"
      "video"
      "networkmanager"
    ];
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
}
