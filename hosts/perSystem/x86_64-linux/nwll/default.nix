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
    steam.enable = true;
    fish.enable = true;
  };

  services = {
    mullvad-vpn = {
      enable = true;
      package = pkgs.stable.mullvad-vpn;
    };
  };

  # # exclude mullvad from 8096
  # networking.nftables = {
  #   enable = true;
  #   tables = {
  #     excludeTraffic = {
  #       family = "inet";
  #       content = ''
  #         chain allowIncoming {
  #           type filter hook prerouting priority -200; policy accept;
  #           tcp dport 8096 ct mark set 0x00000f41 meta mark set 0x6d6f6c65
  #         }
  #         chain allowOutgoing {
  #           type route hook output priority -100; policy accept;
  #           tcp sport 8096 ct mark set 0x00000f41 meta mark set 0x6d6f6c65
  #         }
  #       '';
  #     };
  #   };
  # };

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
          # prismlauncher
          audacity
          figma-agent
          delfin

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
