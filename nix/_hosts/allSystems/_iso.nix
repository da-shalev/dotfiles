{ lib, self, ... }: {
  time.hardwareClockInLocalTime = lib.mkDefault true;
  hardware.graphics.enable = true;
  imports = [ self.modules.nixos.user ];
}
