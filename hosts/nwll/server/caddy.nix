{ config, ... }: {
  services.caddy = {
    enable = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  environment.persistence."/nix/persist" = {
    directories = [ config.services.caddy.dataDir ];
  };
}
