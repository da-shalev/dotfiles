{ self, ... }: {
  imports = [ ./steam.nix ./chromium.nix self.modules.nixos.mullvad-vpn ];
}
