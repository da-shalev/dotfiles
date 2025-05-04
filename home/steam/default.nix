{ config, pkgs, lib, ... }: {
  options.h.steam = {
    enable =
      lib.mkEnableOption "Enables steam and gives you permission to run it."
      // {
        default = false;
      };
  };

  config = lib.mkIf config.h.steam.enable {
    users = {
      groups.steam = { };
      users = {
        steam = {
          isSystemUser = true;
          home = "/var/lib/steam";
          group = "steam";
          extraGroups = [ "wheel" "video" ];
        };
        ${config.h.userName} = { extraGroups = [ "steam" ]; };
      };
    };

    environment.persistence."/nix/persist" = {
      directories = [{
        directory = "/var/lib/steam";
        user = "steam";
        group = "steam";
        mode = "0775";
      }];
    };

    programs.steam = {
      enable = true;
      package =
        pkgs.steam.override { extraEnv = { HOME = "/var/lib/steam"; }; };
    };
  };
}
