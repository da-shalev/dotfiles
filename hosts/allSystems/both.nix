{
  inputs,
  lib,
  pkgs,
  config,
  self,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.nix-maid.nixosModules.default
    inputs.preservation.nixosModules.default
    self.modules.nixos.rebuild
    ./nixcfg.nix
  ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  maid.sharedModules = with self.modules.maid; [
    shell
    wayland
    tmux
    fish
    hyprland
  ];

  fonts = lib.mkIf config.hardware.graphics.enable {
    enableDefaultPackages = false;
    packages = with pkgs; [
      corefonts
      iosevka
      inter
      nerd-fonts.symbols-only
      twitter-color-emoji
      fraunces
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "Fraunces"
          "Symbols Nerd Font"
        ];
        sansSerif = [
          "Inter Variable"
          "Symbols Nerd Font"
        ];
        monospace = [
          "Iosevka"
          "Symbols Nerd Font Mono"
        ];
        emoji = [ "Twitter Color Emoji" ];
      };
    };
  };

  console = {
    packages = with pkgs; [ spleen ];
    font = "spleen-16x32";
  };

  networking.firewall = {
    allowedTCPPorts = [
      22
      25565
      4321
      8096
      8097
      2234
      8888
      5173
    ];
  };

  rebuild.dir = "dotfiles";
  time.timeZone = lib.mkDefault "Canada/Eastern";

  programs = {
    fish.package = lib.mkDefault pkgs.fishMinimal;
    appimage = {
      enable = true;
      binfmt = true;
    };

    gnupg.agent.enable = true;
    localsend = { inherit (config.hardware.graphics) enable; };
    direnv = {
      enable = true;
      silent = true;
    };

    command-not-found.enable = false;
    git.enable = true;
  };

  environment = {
    defaultPackages = [ ];

    variables = {
      ALSA_CONFIG_UCM2 = "${
        pkgs.stable.alsa-ucm-conf.overrideAttrs (old: {
          src = inputs.alsa-ucm-conf;
        })
      }/share/alsa/ucm2";
    };

    systemPackages = with pkgs; [
      usbutils
      pciutils
      file
      libva-utils
      (lib.mkIf (builtins.elem "nvidia" config.services.xserver.videoDrivers) nvitop)
    ];

    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
    };
    localBinInPath = lib.mkDefault true;
  };

  users.mutableUsers = lib.mkDefault false;
  security.rtkit = { inherit (config.services.pipewire) enable; };

  services = {
    gvfs.enable = true;
    fstrim.enable = true;
    pulseaudio.enable = lib.mkForce false;
    udisks2.enable = true;
    dbus.implementation = "broker";
    userborn.enable = true;
    openssh.enable = true;
    rsyncd.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;

      wireplumber.extraConfig."zz-device-profiles" = {
        "monitor.alsa.rules" = [
          {
            matches = [ { "device.name" = "alsa_card.pci-0000_01_00.1"; } ];
            actions = {
              update-props = {
                "device.profile" = "off";
              };
            };
          }
          {
            matches = [
              {
                "device.name" = "alsa_card.usb-Focusrite_Scarlett_Solo_4th_Gen_S12A7663300686-00";
              }
            ];
            actions = {
              update-props = {
                "device.profile" = "pro-audio";
              };
            };
          }
          {
            matches = [ { "device.name" = "alsa_card.usb-Topping_DX3_Pro_-00"; } ];
            actions = {
              update-props = {
                "device.profile" = "pro-audio";
              };
            };
          }
        ];
      };
    };
  };

  preservation.preserveAt."/nix/persist" = {
    commonMountOptions = [
      "x-gvfs-hide"
      "x-gdu.hide"
    ];
    directories = [
      "/var/log"
      "/var/lib/systemd/coredump"
      {
        directory = "/tmp";
        mode = "1777";
      }
    ]
    ++ lib.optionals config.networking.networkmanager.enable [
      "/var/lib/NetworkManager/"
      "/etc/NetworkManager/"
    ]
    ++ lib.optionals config.hardware.bluetooth.enable [ "/var/lib/bluetooth/" ]
    ++ lib.optionals config.services.mullvad-vpn.enable [
      "/etc/mullvad-vpn"
      "/var/cache/mullvad-vpn"
    ]
    ++ lib.optionals config.services.jellyfin.enable [
      {
        directory = config.services.jellyfin.configDir;
        user = config.services.jellyfin.user;
        group = config.services.jellyfin.group;
      }
      {
        directory = config.services.jellyfin.cacheDir;
        user = config.services.jellyfin.user;
        group = config.services.jellyfin.group;
      }
      {
        directory = config.services.jellyfin.dataDir;
        user = config.services.jellyfin.user;
        group = config.services.jellyfin.group;
      }
      {
        directory = config.services.jellyfin.logDir;
        user = config.services.jellyfin.user;
        group = config.services.jellyfin.group;
      }
    ];
    files = [
      {
        file = "/var/lib/systemd/random-seed";
        how = "symlink";
        inInitrd = true;
        configureParent = true;
      }
      {
        file = "/etc/machine-id";
        inInitrd = true;
        how = "symlink";
        configureParent = true;
      }
    ];
  };

  systemd = {
    suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
    services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ];
  };

  hardware.bluetooth.settings.General = {
    Enable = "Source,Sink,Media,Socket";
    Experimental = true;
  };
}
