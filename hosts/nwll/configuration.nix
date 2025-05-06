{ pkgs, inputs, ... }: {
  users.users.dashalev = {
    uid = 1000;
    extraGroups = [ "wheel" "video" "networkmanager" ];
    initialPassword = "boobs";
  };

  security.sudo.wheelNeedsPassword = false;

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.systemd.enable = true;
  };

  fonts = {
    packages = with pkgs; [
      corefonts
      inter
      inputs.apple-emoji-linux.packages.${pkgs.system}.apple-emoji-linux
      cascadia-code
      nerd-fonts.symbols-only
    ];

    fontconfig = {
      enable = true;
      hinting.enable = false;
      defaultFonts = {
        serif = [ "Inter" ];
        sansSerif = [ "Inter" ];
        monospace = [ "Cascadia Code" "Symbols Nerd Font Mono" ];
        emoji = [ "Apple Color Emoji" ];
      };
    };
  };

  system.stateVersion = "24.05";
}
