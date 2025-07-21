{
  imports = [ ./steam.nix ./chromium.nix ];
  programs = { localsend.enable = true; };
  services.mullvad-vpn.enable = true;
  environment.persistence."/nix/persist" = {
    directories = [ "/etc/mullvad-vpn" "/var/cache/mullvad-vpn" ];
  };
}
