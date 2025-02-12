{ pkgs, lib, config, ... }: {
  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/bluetooth/"
      "/var/lib/NetworkManager/"
      "/etc/NetworkManager/"
    ];
  };

  networking.networkmanager = { enable = true; };

  services = {
    xserver.videoDrivers = [ "nvidia" ];
    blueman.enable = true;
    scx = {
      enable = true;
      package = pkgs.scx.full;
      scheduler = "scx_bpfland";
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    tmp.cleanOnBoot = true;
  };

  powerManagement.cpuFreqGovernor = "performance";

  hardware = {
    enableAllFirmware = lib.mkForce true;
    wirelessRegulatoryDatabase = true;
    bluetooth = {
      inherit (config.hardware.graphics) enable;
      powerOnBoot = lib.mkDefault true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
      extraPackages32 = with pkgs; [ nvidia-vaapi-driver ];
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };

      nvidiaPersistenced = false;

      open = false;
      nvidiaSettings = false;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };

  boot = {
    kernelModules = [ "nvidia-uvm" "ctr" ];
    blacklistedKernelModules = [ "amdgpu" "radeon" ];
    kernelParams = [ "nvidia-drm.fbdev=1" "nvidia-drm.modeset=1" ];
    initrd.availableKernelModules =
      [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "uas" ];
  };

  networking.useDHCP = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
