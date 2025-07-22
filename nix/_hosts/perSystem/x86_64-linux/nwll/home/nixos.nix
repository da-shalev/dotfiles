{ pkgs, self', self, inputs', ... }: {
  programs.fish.enable = true;
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.hyprland = {
    enable = true;
    package = inputs'.hyprland.packages.hyprland;
    portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
  };

  xdg.portal.config.common = { hyprland = [ "hyprland" "gtk" ]; };

  users.users.nixos = {
    uid = 1000;
    extraGroups = [ "wheel" "video" "networkmanager" ];
    isNormalUser = true;
    shell = pkgs.fish;

    maid = {
      imports = [
        self.modules.maid.shell
        self.modules.maid.wayland
        self.modules.maid.tmux
        self.modules.maid.fish
        self.modules.maid.hyprland
        self.modules.maid.dashalev
      ];

      packages = with pkgs; [
        foot
        pwvucontrol_git
        nautilus
      ];

      shell = {
        package = pkgs.fish;
        colour = "green";
        icon = "🍺";
      };

      hyprland = {
        enable = true;
        extraConfig = ''
          monitor=Virtual-1,highres@highrr,auto,1
        '';
      };

      wayland = { enable = true; };
    };
  };
}
