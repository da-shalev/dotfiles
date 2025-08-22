{ ... }: {
  boot = {
    tmp.cleanOnBoot = true;
  };

  hardware = {
    enableAllFirmware = true;

    amdgpu.initrd.enable = true;
  };
}
