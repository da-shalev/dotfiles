{ self, pkgs, ... }: {
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "virtio_pci" "usbhid" "usb_storage" "sr_mod" ];

  system.stateVersion = "25.11";

  imports = [ self.modules.nixos.hyprland ./disko.nix ];
  programs.fish.enable = true;

  users.users.dashalev = {
    uid = 1000;
    extraGroups = [ "wheel" "video" "networkmanager" "dotfiles" ];
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

      shell = {
        package = pkgs.fish;
        colour = "green";
        icon = "📦";
      };

      hyprland = {
        mod = "ALT";
        enable = true;

        # exclude dock, 120
        # monitor=Virtual-1, modeline 1031.00 3024 3296 3632 4240 1890 1893 1899 2027 -hsync +vsync, 0x0, 1
        # include dock, 120
        # monitor=Virtual-1, modeline 1071.50 3024 3296 3632 4240 1964 1967 1977 2106 -hsync +vsync, 0x0, 1
        # exclude dock, 60
        # monitor=Virtual-1, modeline 488.50 3024 3264 3592 4160 1890 1893 1899 1958 -hsync +vsync, 0x0, 1
        extraConfig = ''
          monitor=Virtual-1, modeline 488.50 3024 3264 3592 4160 1890 1893 1899 1958 -hsync +vsync, 0x0, 1
          input {
            scroll_factor=0.2
            natural_scroll=true
          }
        '';
      };

      wayland = {
        enable = true;
        cursor_theme.size = 48;
      };
    };
  };
}
