{ pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [
      vesktop
      onlyoffice-desktopeditors
      zathura
      prismlauncher
      obs-studio
      aseprite
      ghostty
      nushell
      # blender
      signal-desktop
      mullvad-vpn
    ];
  };
}
