# NOTE: This configuration is global and applies to all systems.
# Therefore, anything written here must be compatible with
# all option variance. For the most part, each system should have its unique config.

# DARWIN OPTIONS: https://daiderd.com/nix-darwin/manual/index.html
# LINUX OPTIONS: https://search.nixos.org/options

{ config, ... }: {
  # LMAO
  networking = { inherit (config.systemGenesis) hostName; };

  programs = {
    direnv = {
      nix-direnv.enable = true;
      enable = true;
      silent = true;
    };
  };

  environment.sessionVariables = {
    CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    GNUPGHOME = "$XDG_DATA_HOME/gnupg";
    NIXPKGS_ALLOW_UNFREE = 1;
  };
}
