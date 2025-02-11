{ darwinGenesis, darwinUser, ... }: {
  flake.darwinConfigurations.refrigerator =
    darwinGenesis "aarch64-darwin" "refrigerator" [
      ./configuration.nix
      ./homebrew.nix
      (darwinUser "dashalev" [ ./Users/dashalev.nix ])
    ];
}
