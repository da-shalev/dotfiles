{
  description = "Shalev's blood.";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    import-tree.url = "github:vic/import-tree";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-maid.url = "github:viperML/nix-maid";
    wrapper-manager.url = "github:viperML/wrapper-manager";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    mnw.url = "github:Gerg-L/mnw";
    hyprland.url = "github:hyprwm/Hyprland";

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alsa-ucm-conf = {
      url = "github:geoffreybennett/alsa-ucm-conf";
      flake = false;
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ (inputs.import-tree ./nix) ];
    };
}
