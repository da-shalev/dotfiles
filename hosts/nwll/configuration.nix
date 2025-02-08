{ inputs, pkgs, ... }: {
  users.users.dashalev = {
    shell = pkgs.fish;
    uid = 1000;
  };

  security.sudo.wheelNeedsPassword = false;

  fonts = {
    packages = with pkgs; [
      corefonts
      inter
      # inputs.self.packages.${pkgs.system}.apple-emoji-linux
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
