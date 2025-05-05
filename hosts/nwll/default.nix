{ inputs, linuxGenesis, linuxUser, ... }: {
  flake.nixosConfigurations.nwll = linuxGenesis "x86_64-linux" "nwll" [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.chaotic.nixosModules.default
    ./disko
    ./hardware.nix
    ./configuration.nix
    ./programs.nix
    # ./server
    (linuxUser "dashalev" [ ./home/dashalev.nix ])
  ];
}
