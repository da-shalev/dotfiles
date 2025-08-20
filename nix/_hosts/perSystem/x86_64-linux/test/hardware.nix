{ lib, pkgs, ... }: {
  boot = {
    tmp.cleanOnBoot = true;
    kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;
  };

  hardware = {
    enableAllFirmware = true;

    amdgpu.initrd.enable = true;
  };
}
