{ pkgs, inputs, packages, stable, ... }:
let
in {
  environment = {
    systemPackages = with pkgs; [
      inputs.zen-browser.packages.${pkgs.system}.default
      chromium

      stable.aseprite
      krita
      onlyoffice-desktopeditors
      zathura

      signal-desktop
      nvitop

      mullvad-vpn
      qbittorrent
      mission-center
      alsa-scarlett-gui
    ];
  };
}
