{ lib, ... }: {
  time.hardwareClockInLocalTime = lib.mkDefault true;
}
