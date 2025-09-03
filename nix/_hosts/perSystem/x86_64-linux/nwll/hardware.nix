{ pkgs, lib, config, ... }: {
  networking.networkmanager = {
    enable = true;
    wifi = { powersave = false; };
  };

  services = {
    xserver.videoDrivers = [ "nvidia" ];
    scx = {
      package = pkgs.stable.scx.rustscheds;
      enable = true;
      scheduler = "scx_lavd";
    };
  };

  boot = {
    kernel.sysctl."kernel.unprivileged_userns_clone" = 1;
    kernelPackages = pkgs.linuxPackages_cachyos;
    tmp.cleanOnBoot = true;

    extraModulePackages = [ config.boot.kernelPackages.kvmfr ];

    kernelParams = [
      # laptops and dekstops don't need Watchdog
      "nowatchdog"
      # https://www.phoronix.com/news/Linux-Splitlock-Hurts-Gaming
      "split_lock_detect=off"
      # enable AMD IOMMU hardware + passthrough mode
      "amd_iommu=on"
      "iommu=pt"
    ];

    kernelModules = [
      # load VFIO driver for device passthrough
      "vfio-pci"
      # looking glass kernel module
      "kvmfr"
    ];

    blacklistedKernelModules = [
      # prevent amdgpu drivers from being loaded, disable igpu
      "amdgpu"
      # blacklist its audio module
      "snd_hda_intel"
    ];

    extraModprobeConfig = ''
      options vfio-pci ids=1002:13c0,1002:1640
      options kvmfr static_size_mb=256
    '';
  };

  # add group "kvm" to gain permission to access the actual gpu device
  services.udev.extraRules = ''
    SUBSYSTEM=="vfio", OWNER="dashalev", GROUP="kvm", MODE="0660"
    SUBSYSTEM=="kvmfr", OWNER="dashalev", GROUP="kvm", MODE="0660"
  '';

  # increase pathetic 8MB of vram limit for VMS
  systemd.settings.Manager.DefaultLimitMEMLOCK = "infinity";

  powerManagement.cpuFreqGovernor = "performance";

  hardware = {
    enableAllFirmware = true;
    bluetooth.enable = true;

    graphics = {
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
      extraPackages32 = with pkgs; [ nvidia-vaapi-driver ];
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      open = true;
      nvidiaSettings = false;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };

  boot = {
    initrd.availableKernelModules =
      [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "uas" ];
  };

  networking.useDHCP = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
