{ inputs,  ... }: {
  perSystem = { system, pkgs, inputs', ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ inputs.chaotic.overlays.default ];
    };

    packages = {
      neovim = inputs.mnw.lib.wrap pkgs (import ./_neovim pkgs);
      firefox = import ./_mozilla/firefox.nix { inherit inputs' inputs pkgs; };
      zen-browser = import ./_mozilla/zen-browser.nix { inherit inputs' inputs pkgs; };
    };
  };
}
