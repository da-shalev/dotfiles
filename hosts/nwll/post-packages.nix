{ pkgs, stable, ... }: {
  environment = {
    systemPackages = with pkgs; [
      (writeShellScriptBin "davinci-resolve" ''
        QT_QPA_PLATFORM=xcb ${stable.davinci-resolve}/bin/davinci-resolve
      '')

      mangohud
      torzu_git
      ryujinx
      prismlauncher
      airshipper
    ];
  };
}
