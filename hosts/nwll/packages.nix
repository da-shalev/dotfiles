{ pkgs, stable, ... }: {
  environment = {
    systemPackages = with pkgs; [
      chromium
      delfin
      (brave.override {
        commandLineArgs =
          [ "--enable-features=WaylandLinuxDrmSyncobj,RustyPng" ];
      })

      aseprite
      vesktop
      stable.wine64
      blender
      krita
      gimp3
      onlyoffice-desktopeditors
      zathura

      signal-desktop-bin
      nvitop

      mullvad-vpn
      qbittorrent
      mission-center
      # alsa-scarlett-gui
    ];
  };
}
