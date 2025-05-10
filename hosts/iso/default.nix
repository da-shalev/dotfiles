{ linuxGenesis, ... }: {
  flake.nixosConfigurations.iso = linuxGenesis "x86_64-linux" "iso" [
    ./configuration.nix
  ];
}
