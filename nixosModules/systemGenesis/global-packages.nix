{ pkgs, config, lib, ... }: {
  environment = {
    variables.NIXPKGS_CONFIG = lib.mkForce "${config.systemGenesis.configDir}";
    systemPackages = with pkgs; [
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
  };
}
