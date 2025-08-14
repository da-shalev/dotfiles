{ pkgs, lib, config, ... }: {
  services = {
    xserver.videoDrivers = [ "nvidia" ];
    blueman.enable = true;
    scx = {
      enable = true;
      scheduler = "scx_lavd";
    };

    pipewire.wireplumber.extraConfig."zz-device-profiles" = {
      "monitor.alsa.rules" = [
        {
          matches = [{ "device.name" = "alsa_card.pci-0000_01_00.1"; }];
          actions = { update-props = { "device.profile" = "off"; }; };
        }
        {
          matches = [{
            "device.name" =
              "alsa_card.usb-Focusrite_Scarlett_Solo_4th_Gen_S12A7663300686-00";
          }];
          actions = { update-props = { "device.profile" = "pro-audio"; }; };
        }
        {
          matches = [{ "device.name" = "alsa_card.usb-Topping_DX3_Pro_-00"; }];
          actions = { update-props = { "device.profile" = "pro-audio"; }; };
        }
      ];
    };
  };

  boot = {
    kernelParams = [
      # Laptops and dekstops don't need Watchdog
      "nowatchdog"
      # https://www.phoronix.com/news/Linux-Splitlock-Hurts-Gaming
      "split_lock_detect=off"
      # Input–Output Memory Management Unit, grants VM exclusive DMA access to igpu
      # "amd_iommu=on"
      # "iommu=pt"
    ];

    # # Load KVM and VFIO modules so QEMU can use hardware acceleration and pass the AMD iGPU
    # kernelModules = [ "kvm_amd" "vfio-pci" ];
    # prevent amdgpu drivers from being loaded, disable igpu
    blacklistedKernelModules = [ "amdgpu" ];

    # # vfio-pci only binds ID 1002:13c0
    # extraModprobeConfig = ''
    #   options vfio-pci ids=1002:13c0
    # '';

    kernel.sysctl."kernel.unprivileged_userns_clone" = 1;
    # kernelPackages = pkgs.linuxPackages_cachyos-rc;
    #kernelPackages = pkgs.linuxPackages_6_12;
    kernelPackages = pkgs.linuxPackages_cachyos;
    tmp.cleanOnBoot = true;
  };

  powerManagement.cpuFreqGovernor = "performance";

  hardware = {
    enableAllFirmware = true;
    bluetooth.enable = true;

    graphics = {
      enable = true;
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
