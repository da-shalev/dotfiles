{ pkgs, inputs, stable, ... }: {
  environment = {
    systemPackages = with pkgs; [
      inputs.zen-browser.packages.${pkgs.system}.default
      ungoogled-chromium

      ghostty
      cool-retro-term
      zed-editor_git

      aseprite
      (writeShellScriptBin "davinci-resolve" ''
        QT_QPA_PLATFORM=xcb ${stable.davinci-resolve}/bin/davinci-resolve
      '')
      onlyoffice-desktopeditors
      zathura

      signal-desktop
      vesktop

      mullvad-vpn
      qbittorrent
      mission-center

      # games
      torzu_git
      prismlauncher
      airshipper
    ];
  };
}
