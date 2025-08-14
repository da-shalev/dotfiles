{ lib, ... }: {
  time.hardwareClockInLocalTime = lib.mkDefault true;
  hardware.graphics.enable = true;
}
