{ inputs, lib, pkgs, config, self, ... }: {
  imports = [
    inputs.disko.nixosModules.disko
    inputs.nix-maid.nixosModules.default
    inputs.impermanence.nixosModules.impermanence
    self.modules.nixos.rebuild
    self.modules.nixos.environment
    self.modules.nixos.fonts
  ];

  hardware = {
    graphics.enable = true;
    wirelessRegulatoryDatabase = true;
  };

  networking.firewall = { allowedTCPPorts = [ 4321 8096 8097 ]; };

  rebuild.dir = "dotfiles";
  documentation = {
    enable = true;
    man.enable = true;
    doc.enable = false;
    nixos.enable = false;
    info.enable = false;
  };

  time.timeZone = lib.mkDefault "Canada/Eastern";
  nix = {
    package = pkgs.nixVersions.latest;
    registry.nixpkgs.flake = lib.mkOverride 3 inputs.nixpkgs;
    channel.enable = false;
    settings = {
      nix-path = "nixpkgs=flake:nixpkgs";
      max-substitution-jobs = 128;
      download-buffer-size = 134217728;
      substituters = [
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://chaotic-nyx.cachix.org/"
      ];
      trusted-substituters = [
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://chaotic-nyx.cachix.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
      extra-experimental-features = [
        "nix-command"
        "flakes"
        "cgroups"
        "auto-allocate-uids"
        "fetch-closure"
        "dynamic-derivations"
        "pipe-operators"
      ];
      use-cgroups = true;
      auto-allocate-uids = true;
      warn-dirty = false;
      trusted-users = [ "@wheel" ];
      allowed-users = lib.mapAttrsToList (_: u: u.name)
        (lib.filterAttrs (_: user: user.isNormalUser) config.users.users);
    };
  };

  system = {
    rebuild.enableNg = true;
    tools.nixos-option.enable = false;
  };

  programs = {
    localsend.enable = true;
    direnv = {
      enable = true;
      silent = true;
    };

    command-not-found.enable = false;
    fuse.userAllowOther = true;
    git = { enable = true; };
  };

  environment = {
    # override all default packages from nix
    defaultPackages = [ ];
    systemPackages = with pkgs; [
      # utils
      usbutils
      pciutils
      file
      libva-utils

      # me
      ffmpeg-full
      yt-dlp
      wget
      unzip
      p7zip
      zip
      tree
      vimv
      onefetch
      fastfetch
      btop
      htop
      dysk
      bat
      hyperfine

      asciiquarium-transparent
      nyancat
      cmatrix
      sl
      nix-tree
      rsync

      foot
      pwvucontrol
      nautilus
    ];
  };

  users.mutableUsers = lib.mkDefault false;
  security = { rtkit = { inherit (config.services.pipewire) enable; }; };

  services = {
    fstrim.enable = true;
    pulseaudio.enable = false;
    udisks2.enable = true;
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
