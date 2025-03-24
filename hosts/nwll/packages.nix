{ pkgs, inputs, packages, stable, ... }: {
  environment = {
    systemPackages = with pkgs; [
      inputs.zen-browser.packages.${pkgs.system}.default
      chromium

      aseprite
      krita
      onlyoffice-desktopeditors
      zathura

      signal-desktop

      mullvad-vpn
      qbittorrent
      mission-center
      alsa-scarlett-gui
    ];
  };
}
