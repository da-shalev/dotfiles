{
  self,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./disko.nix
    self.modules.nixos.no-sleep
    self.modules.nixos.hyprland
  ];

  rebuild.owner = "dashalev";

  programs = {
    # steam.enable = true;
    fish.enable = true;
  };

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.stable.mullvad-vpn;
  };

  preservation = {
    enable = true;
    preserveAt."/nix/persist".directories = [
      {
        directory = config.users.users.dashalev.home;
        user = "dashalev";
        group = "users";
      }
      {
        directory = config.users.users.sandbox.home;
        user = "sandbox";
        group = "users";
      }
    ];
  };

  programs.steam.enable = true;

  users.users = {
    # USER: nwll - dashalev
    dashalev = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "video"
        "networkmanager"
        "kvm"
        "input"
      ];
      shell = pkgs.fish;
      initialPassword = "boobs";

      maid = {
        imports = with self.modules.maid; [ dashalev ];
        packages = with pkgs; [
          obs-studio
          ungoogled-chromium
          signal-desktop-bin
          telegram-desktop
          vulkan-hdr-layer-kwin6
          prismlauncher
          looking-glass-client
          audacity
          figma-agent

          qbittorrent
          nicotine-plus

          # davinci-resolve
          tutanota-desktop
          heroic
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
            env=GSK_RENDERER,ngl
            exec-once=${lib.getExe pkgs.mpd}
          '';
        };

        wayland = {
          enable = true;
          cursor_theme.size = lib.mkDefault 40;
        };
      };
    };

    # USER: nwll - sandbox
    sandbox = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "video"
        "networkmanager"
      ];
      shell = pkgs.fish;
      initialPassword = "boobs";

      maid = {
        imports = with self.modules.maid; [ dashalev ];
        packages = with pkgs; [
          qbittorrent
          nicotine-plus
          heroic
        ];

        shell = {
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
  };
}
