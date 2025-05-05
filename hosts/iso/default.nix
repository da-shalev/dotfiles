{ inputs, linuxGenesis, ... }: {
  flake.nixosConfigurations.iso = linuxGenesis "x86_64-linux" "iso" [
    inputs.chaotic.nixosModules.default
    ./configuration.nix
  ];
}
