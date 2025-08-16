{ lib, self, ... }: {
  time.hardwareClockInLocalTime = lib.mkDefault true;
  imports = [ self.modules.nixos.user ];
}
