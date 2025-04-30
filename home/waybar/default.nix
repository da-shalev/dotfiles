{ config, lib, ... }: {
  options.h.waybar = {
    enable = lib.mkEnableOption "Enables waybar" // { default = false; };
    launch = lib.mkEnableOption "Start automagically" // { default = false; };
  };

  config =
    lib.mkIf config.h.waybar.enable { programs.waybar = { enable = true; }; };
}
