{ inputs, lib, pkgs, config, self, ... }: {
  imports = [
    inputs.disko.nixosModules.disko
    inputs.nix-maid.nixosModules.default
    inputs.impermanence.nixosModules.impermanence
    self.modules.nixos.rebuild
    self.modules.nixos.environment
    self.modules.nixos.fonts
    ./nixcfg.nix
  ];

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    # zfs.package = lib.mkOverride 99 pkgs.zfs_cachyos;
    supportedFilesystems = { zfs = lib.mkForce false; };
  };

  console = {
    packages = with pkgs; [ spleen ];
    font = "spleen-16x32";
  };

  networking.firewall = {
    allowedTCPPorts = [ 22 25565 4321 8096 8097 2234 8888 ];
  };

  rebuild.dir = "dotfiles";
  time.timeZone = lib.mkDefault "Canada/Eastern";

  programs = {
    fish.package = lib.mkDefault pkgs.fishMinimal;
    appimage = {
      enable = true;
      binfmt = true;
    };
    gnupg.agent.enable = true;
    localsend = { inherit (config.hardware.graphics) enable; };
    direnv = {
      enable = true;
      silent = true;
    };

    command-not-found.enable = false;
    git = { enable = true; };
  };

  environment = {
    defaultPackages = [ ];
    systemPackages = with pkgs; [
      # utils
      usbutils
      pciutils
      file
      libva-utils
    ];
  };

  users.mutableUsers = lib.mkDefault true;
  security = { rtkit = { inherit (config.services.pipewire) enable; }; };

  services = {
    fstrim.enable = true;
    pulseaudio.enable = lib.mkForce false;
    # udisks2.enable = true;
    dbus.implementation = "broker";
    openssh.enable = true;
    rsyncd.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;

      wireplumber.extraConfig."zz-device-profiles" = {
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
            matches =
              [{ "device.name" = "alsa_card.usb-Topping_DX3_Pro_-00"; }];
            actions = { update-props = { "device.profile" = "pro-audio"; }; };
          }
        ];
      };
    };
  };
}
