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
    kernelPackages = lib.mkDefault pkgs.linuxPackages_testing;
    # zfs.package = lib.mkOverride 99 pkgs.zfs_cachyos;
    supportedFilesystems = { zfs = lib.mkForce false; };
  };

  console = {
    packages = with pkgs; [ spleen ];
    font = "spleen-16x32";
  };

  networking.firewall = {
    allowedTCPPorts = [ 25565 4321 8096 8097 2234 8888 ];
  };

  rebuild.dir = "dotfiles";
  # documentation = {
  #   enable = true;
  #   man.enable = true;
  #   doc.enable = false;
  #   nixos.enable = false;
  #   info.enable = false;
  # };

  time.timeZone = lib.mkDefault "Canada/Eastern";

  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    gnupg.agent.enable = true;
    localsend.enable = true;
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
    # gvfs.enable = true;
    fstrim.enable = true;
    pulseaudio.enable = lib.mkForce false;
    # udisks2.enable = true;
    dbus.implementation = "broker";
    openssh.enable = true;
    rsyncd.enable = true;
    pipewire = {
      inherit (config.hardware.graphics) enable;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
    };
  };
}
