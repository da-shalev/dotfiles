{
  flake.modules.maid.hyprland = { config, lib, pkgs, ... }: {
    options.hyprland = {
      enable = lib.mkEnableOption "Configures hyprland." // {
        default = false;
      };

      mod = lib.mkOption {
        type = lib.types.str;
        default = "SUPER";
      };

      config = lib.mkOption {
        type = lib.types.lines;
        default = "";
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
      };
    };

    config = lib.mkIf config.fish.enable {
      file.xdg_config."hypr/hyprland.conf".text = ''
        $mod=${config.hyprland.mod}
        ${config.hyprland.config}
        ${config.hyprland.extraConfig}
      '';
    };
  };
}
