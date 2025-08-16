{ pkgs, ... }: {
  nixos-user = {
    maid = {
      packages = with pkgs; [ zathura ];
      hyprland = {
        enable = true;
        extraConfig = ''
          monitor=Virtual-1,modeline 173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync,0x0,1
        '';
      };
    };
  };
}
