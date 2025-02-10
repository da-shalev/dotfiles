# NOTE: This configuration is global and applies to all systems.
# Therefore, anything written here must be compatible with
# all option variance. For the most part, each system should have its unique config.

# DARWIN OPTIONS: https://daiderd.com/nix-darwin/manual/index.html
# LINUX OPTIONS: https://search.nixos.org/options

{ lib, config, ... }: {
  # LMAO
  networking = { inherit (config.systemGenesis) hostName; };
  time.timeZone = lib.mkDefault "Canada/Eastern";
}
