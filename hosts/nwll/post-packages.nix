{ pkgs, stable, ... }: {
  environment = {
    systemPackages = with pkgs; [
      (writeShellScriptBin "davinci-resolve" ''
        QT_QPA_PLATFORM=xcb ${davinci-resolve}/bin/davinci-resolve
      '')

      mangohud
      torzu_git
      heroic
      cemu
      prismlauncher
      airshipper
    ];
  };
}
