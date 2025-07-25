{ lib, self, ... }: {
  imports = [ self.modules.nixos.mullvad-vpn ];
  time.hardwareClockInLocalTime = lib.mkDefault true;
}
