{
  flake.modules.nixos.mullvad-vpn = { lib, pkgs, ... }: {
    services.mullvad-vpn.enable = true;
    environment.persistence."/nix/persist" = {
      directories = [ "/etc/mullvad-vpn" "/var/cache/mullvad-vpn" ];
    };

    environment.systemPackages = with pkgs; [ mullvad-vpn ];
  };
}
