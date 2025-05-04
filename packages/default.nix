{ inputs, pkgs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.neovim = inputs.mnw.lib.wrap pkgs (import ./neovim pkgs);
  };
}
