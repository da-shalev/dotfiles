{ pkgs, inputs, ... }: {
  users.users.dashalev = {
    uid = 1000;
    extraGroups = [ "wheel" "video" "networkmanager" ];
    initialPassword = "boobs";
  };

  security.sudo.wheelNeedsPassword = false;

  fonts = {
    packages = with pkgs; [
      corefonts
      vistafonts
      cascadia-code
      inter
      inputs.apple-emoji-linux.packages.${pkgs.system}.apple-emoji-linux
      nerd-fonts.symbols-only
      spleen
      # (google-fonts.override {
      # # "Georgia" "BodoniModa" "CormorantGaramond" "DMSans"
      #   fonts = [ "CormorantGaramond" "DMSans"  ];
      # })
    ];
    fontconfig = {
      enable = true;
      # hinting.enable = false;
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
