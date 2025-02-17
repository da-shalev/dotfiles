{ inputs, ... }: {
  perSystem = { pkgs, system, ... }: {
    packages = {
      apple-emoji-linux =
        pkgs.callPackage ./apple-emoji-linux.nix { inherit inputs; };
    };
  };
}
