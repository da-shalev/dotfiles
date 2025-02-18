{ pkgs, inputs, ... }: {
  environment = {
    systemPackages = with pkgs; [
      onlyoffice-desktopeditors
      zathura
      aseprite
      ghostty
      prismlauncher
      airshipper
      ungoogled-chromium
      inputs.zen-browser.packages.${pkgs.system}.default
      zed-editor
      signal-desktop
      vesktop
      cool-retro-term
      mullvad-vpn
      qbittorrent
      torzu
    ];
  };
}
