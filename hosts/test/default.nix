{ inputs, linuxGenesis, linuxUser, ... }: {
  flake.nixosConfigurations.test = linuxGenesis "x86_64-linux" "vm" [
    inputs.chaotic.nixosModules.default
    ./disko
    ./configuration.nix
    (linuxUser "test" [ ./home/test.nix ])
  ];
}
