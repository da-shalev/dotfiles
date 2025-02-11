{ pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [
      onlyoffice-desktopeditors
      zathura
      obs-studio
      aseprite
      ghostty
      prismlauncher
      airshipper
      brave
      signal-desktop
      vesktop
      torzu
      cool-retro-term
      mullvad-vpn
      qbittorrent
    ];
  };
}
