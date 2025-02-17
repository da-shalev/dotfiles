{ pkgs, inputs, ... }: {
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
      inputs.zen-browser.packages.${pkgs.system}.default
      zed-editor
      signal-desktop
      vesktop
      cool-retro-term
      mullvad-vpn
      qbittorrent
      ryubing
      torzu
    ];
  };
}
