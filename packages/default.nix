{ inputs, ... }: {
  perSystem = { pkgs, lib, ... }: {
    packages = {
      neovim = inputs.mnw.lib.wrap pkgs (import ./neovim pkgs);
    };
  };
}
