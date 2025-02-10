{ darwinGenesis, darwinUser, ... }: {
  flake.darwinConfigurations.refrigerator =
    darwinGenesis "aarch64-darwin" "refrigerator" [
      ./configuration.nix
      ./homebrew.nix
      (darwinUser "aarch64-darwin" "dashalev" [ ./Users/dashalev.nix ])
    ];
}
