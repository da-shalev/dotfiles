{ self, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./disko
    ./programs
    ./home/dashalev
    ./home/test
    self.modules.nixos.disable-sleep
  ];

  environment.persistence."/nix/persist" = { enable = true; };
  security.sudo.wheelNeedsPassword = false;
  networking.firewall = { allowedTCPPorts = [ 4321 8096 8097 ]; };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.systemd.enable = true;
  };

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      corefonts
      iosevka
      inter
      nerd-fonts.symbols-only
      twitter-color-emoji
    ];

    fontconfig = {
      enable = true;
      hinting.enable = false;
      defaultFonts = {
        serif = [ "Inter" ];
        sansSerif = [ "Inter" ];
        monospace = [ "Iosevka" "Symbols Nerd Font Mono" ];
        emoji = [ "Twitter Color Emoji" ];
      };
    };
  };

  system.stateVersion = "24.05";
}
