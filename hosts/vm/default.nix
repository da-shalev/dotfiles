{ inputs, linuxGenesis, linuxUser, ... }: {
  flake.nixosConfigurations.vm = linuxGenesis "x86_64-linux" "vm" [
    ./disko
    ./configuration.nix
    (linuxUser "test" [ ./home/test.nix ])
  ];
}
