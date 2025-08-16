{ ... }: {
  boot = {
    tmp.cleanOnBoot = true;
  };

  hardware = { enableAllFirmware = true; };
}
