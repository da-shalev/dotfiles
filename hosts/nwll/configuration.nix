{ pkgs, packages, ... }: {
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
    NIXPKGS_ALLOW_BROKEN = 1; 
  };

  fonts = {
    packages = with pkgs; [
      corefonts
      vistafonts
      cascadia-code
      inter
      packages.apple-emoji-linux
      nerd-fonts.symbols-only
      spleen
    ];
    fontconfig.defaultFonts = {
      serif = [ "Inter" "Symbols Nerd Font" ];
      sansSerif = [ "Inter" "Symbols Nerd Font" ];
      monospace = [ "Cascadia Code" "Symbols Nerd Font Mono" ];
      emoji = [ "Apple Color Emoji" ];
    };
  };

  system.stateVersion = "24.05";
}
