{ pkgs, ... }:
# HACK: 'sandbox' steam by any means necessary, to keep the home dir clean
let path = "/var/lib/steam";
in {
  users = {
    groups."steam" = { };
    users = {
      "steam" = {
        isSystemUser = true;
        home = path;
        group = "steam";
        extraGroups = [ "wheel" "video" ];
      };
    };
  };

  environment.persistence."/nix/persist" = {
    directories = [{
      directory = path;
      user = "steam";
      group = "steam";
      mode = "0775";
    }];
  };

  programs.steam = {
    enable = true;
    package = pkgs.steam.override { extraEnv = { HOME = path; }; };
    extraCompatPackages = [ pkgs.proton-ge-custom ];
  };
}
