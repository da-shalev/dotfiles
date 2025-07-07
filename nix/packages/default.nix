{ inputs, ... }: {
  perSystem = { system, pkgs, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ inputs.chaotic.overlays.default ];
    };

    packages = {
      neovim = inputs.mnw.lib.wrap pkgs (import ./_neovim pkgs);
      firefox = import ./_firefox { inherit inputs pkgs; };
    };
  };
}
