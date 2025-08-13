{ pkgs, lib, config, ... }: {
  services = { blueman.enable = true; };

  boot = {
    kernelParams = [
      # Laptops and dekstops don't need Watchdog
      "nowatchdog"
      # https://www.phoronix.com/news/Linux-Splitlock-Hurts-Gaming
      "split_lock_detect=off"
    ];

    kernel.sysctl."kernel.unprivileged_userns_clone" = 1;
    tmp.cleanOnBoot = true;
  };

  powerManagement.cpuFreqGovernor = "performance";

  hardware = {
    enableAllFirmware = lib.mkForce true;
    bluetooth = { inherit (config.hardware.graphics) enable; };
  };

  boot = {
    initrd.availableKernelModules =
      [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "uas" ];
  };

  networking.useDHCP = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
