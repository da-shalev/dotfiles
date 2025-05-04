{ pkgs, packages, lib, config, ... }: {
  environment = {
    variables.NIXPKGS_CONFIG = lib.mkForce config.systemGenesis.configPath;
    systemPackages = with pkgs; [
      ffmpeg-full
      yt-dlp
      wget
      unzip
      p7zip
      rar
      unrar
      zip
      tree
      vimv
      onefetch
      fastfetch
      btop
      htop
      dysk
      bat
      hyperfine
      packages.neovim

      asciiquarium-transparent
      nyancat
      cmatrix
      sl
    ];
  };
}
