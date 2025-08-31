{
  flake.modules.nixos.mullvad-vpn = { lib, pkgs, ... }: {
    services.mullvad-vpn.enable = true;

    preservation.preserveAt."/nix/persist" = {
      directories = [ "/etc/mullvad-vpn" "/var/cache/mullvad-vpn" ];
    };

    environment.systemPackages = with pkgs; [ mullvad-vpn ];
  };
}
