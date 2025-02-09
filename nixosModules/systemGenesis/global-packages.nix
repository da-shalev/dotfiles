{ pkgs, config, lib, ... }: {
  environment = {
    variables.NIXPKGS_CONFIG = lib.mkForce "${config.systemGenesis.configDir}";
    systemPackages = with pkgs; [
      usbutils
      pciutils
      file
      ffmpeg
      wget
      unzip
      p7zip
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
      neovim
    ];

    # override all default packages from nix
    defaultPackages = [ ];
  };
}
