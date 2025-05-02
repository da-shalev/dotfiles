{ inputs, linuxGenesis, linuxUser, ... }: {
  flake.nixosConfigurations.test = linuxGenesis "x86_64-linux" "test" [
    inputs.chaotic.nixosModules.default
    ./disko
    (linuxUser "testuser" [ ./home/testuser.nix ])
  ];
}
