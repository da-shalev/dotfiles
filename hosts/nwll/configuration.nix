{ pkgs, inputs, ... }: {
  users.users.dashalev = {
    shell = pkgs.fish;
    uid = 1000;
  };

  security.sudo.wheelNeedsPassword = false;
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = 1;
    NIXPKGS_ALLOW_UNFREE = 1;
    ENABLE_HDR_WSI = 1;
  };

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
