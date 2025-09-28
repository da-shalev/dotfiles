{ pkgs, lib, self, config, ... }: {
  imports = [ self.modules.nixos.hyprland ];
  programs.fish.enable = true;

  preservation.preserveAt."/nix/persist".directories = [{
    directory = config.users.users.sandbox.home;
    user = "sandbox";
    group = "users";
  }];

  users.users.sandbox = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" "dotfiles" ];
    shell = pkgs.fish;
    initialPassword = "boobs";

    maid = {
      packages = with pkgs; [ qbittorrent nicotine-plus heroic ];

      shell = {
        package = pkgs.fish;
        colour = "cyan";
        icon = "📦";
      };

      hyprland = {
        enable = true;
        extraConfig = ''
          monitor=HDMI-A-1,highrr,auto,1
          monitor=DP-1,highres@highrr,auto,1
          env = GSK_RENDERER,ngl
        '';
      };

      wayland = {
        enable = true;
        cursor_theme.size = lib.mkDefault 40;
      };
    };
  };
}
