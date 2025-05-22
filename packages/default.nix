{ inputs, ... }: {
  perSystem = { system, pkgs, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ inputs.chaotic.overlays.default ];
    };

    packages = {
      neovim = inputs.mnw.lib.wrap pkgs (import ./neovim pkgs);
      firefox = import ./firefox { inherit inputs pkgs; };
    };
  };
}
