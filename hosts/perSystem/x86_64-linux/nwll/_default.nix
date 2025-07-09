{ lib, inputs, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./fileSystems.nix
    ./disko/a.nix
    ./steam.nix
    {
      imports = with inputs.self.modules.nixosModules;
        [
          { h = { userName = "dashalev"; }; }
          paths
          tmux
          wmenu
          hyprland
          wayland
          fish
          rebuild
          dashalev
          ./dashalev
        ];
    }
  ];

  environment.persistence."/nix/persist" = { enable = true; };

  users.users.dashalev = {
    uid = 1000;
    extraGroups = [ "wheel" "video" "networkmanager" "steam" ];
    initialPassword = "boobs";
  };

  security.sudo.wheelNeedsPassword = false;
  networking.firewall = { allowedTCPPorts = [ 4321 8096 8097 ]; };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.systemd.enable = true;
  };

  systemd.targets =
    lib.genAttrs [ "sleep" "suspend" "hibernate" "hybrid-sleep" ]
    (_: { enable = lib.mkForce false; });

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      corefonts
      iosevka
      inter
      cascadia-code
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
