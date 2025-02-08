{ pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [
      vesktop
      onlyoffice-desktopeditors
      zathura
      prismlauncher
      obs-studio
      brave
      firefox
      aseprite
      ghostty
      # blender
      signal-desktop
      mullvad-vpn
    ];
  };
}
