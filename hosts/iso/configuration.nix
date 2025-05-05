{ pkgs, inputs, ... }: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];
  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "25.05";
}
