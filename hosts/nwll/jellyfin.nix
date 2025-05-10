{ config, domain, pkgs, ... }: {

  services = {
    jellyfin = {
      openFirewall = true;
      enable = true;
    };

    caddy.virtualHosts = {
      "jellyfin.${domain}" = {
        extraConfig = ''
          reverse_proxy localhost:8096
        '';
      };
    };
  };

  networking.firewall = { allowedTCPPorts = [ 8096 ]; };

  environment = {
    persistence."/nix/persist" = {
      directories =
        [ config.services.jellyfin.dataDir config.services.jellyfin.cacheDir ];
    };

    systemPackages = with pkgs; [
      mediainfo
      jellyfin-ffmpeg
      jellyfin-media-player
    ];
  };
}
