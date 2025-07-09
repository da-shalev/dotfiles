{ pkgs, lib, config, inputs, ... }: {
  environment = {
    persistence."/nix/persist" = {
      directories = [
        "/var/lib/bluetooth/"
        "/var/lib/NetworkManager/"
        "/etc/NetworkManager/"
      ];
    };

    variables.ALSA_CONFIG_UCM2 = "${
        pkgs.alsa-ucm-conf.overrideAttrs (old: { src = inputs.alsa-ucm-conf; })
      }/share/alsa/ucm2";
  };

  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
  };

  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ];

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
    ];

    kernel.sysctl."kernel.unprivileged_userns_clone" = 1;
    # kernelPackages = pkgs.linuxPackages_cachyos;
    kernelPackages = pkgs.linuxPackages_6_12;
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
