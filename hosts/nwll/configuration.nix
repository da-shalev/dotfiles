{ pkgs, ... }: {
  users.users.dashalev = {
    shell = pkgs.fish;
    uid = 1000;
  };

  security.sudo.wheelNeedsPassword = false;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_BROKEN = 1;
  };

  fonts = {
    packages = with pkgs; [
      corefonts
      inter
      nerd-fonts.caskaydia-cove
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Inter" ];
        sansSerif = [ "Inter" ];
      };
    };
  };

  system.stateVersion = "24.05";
}
