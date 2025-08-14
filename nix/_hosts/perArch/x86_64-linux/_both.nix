{ pkgs, inputs, lib, config, ... }: {
  hardware = {
    nvidia.open = lib.mkDefault false;
    graphics = { enable32Bit = config.hardware.graphics.enable; };
  };

  # currently cachix is only compiled for x86
  programs.hyprland = {
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = with pkgs; [ rar unrar ];
}
