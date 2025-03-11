{ pkgs, inputs, ... }: {
  environment = {
    systemPackages = with pkgs; [
      inputs.zen-browser.packages.${pkgs.system}.default
      chromium

      aseprite
      gimp
      onlyoffice-desktopeditors
      zathura

      signal-desktop

      mullvad-vpn
      qbittorrent
      mission-center
    ];
  };
}
