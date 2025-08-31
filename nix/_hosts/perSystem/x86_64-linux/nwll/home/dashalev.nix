{ pkgs, lib, self, config, ... }: {
  imports = [ self.modules.nixos.hyprland ];
  programs.fish.enable = true;

  preservation.preserveAt."/nix/persist".directories = [{
    directory = config.users.users.dashalev.home;
    user = "dashalev";
    group = "users";
  }];

  users.users.dashalev = {
    uid = 1000;
    extraGroups = [ "wheel" "video" "networkmanager" "kvm" "input" ];
    isNormalUser = true;
    shell = pkgs.fish;
    initialPassword = "boobs";

    maid = {
      imports = with self.modules.maid; [
        shell
        wayland
        tmux
        fish
        hyprland
        dashalev
      ];

      packages = with pkgs; [
        obs-studio
        ungoogled-chromium
        signal-desktop-bin
        telegram-desktop
        vulkan-hdr-layer-kwin6
        prismlauncher
        looking-glass-client
        audacity
        mtpfs

        qbittorrent
        nicotine-plus

        davinci-resolve
      ];

      shell = {
        package = pkgs.fish;
        colour = "magenta";
        icon = "🗿";
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
