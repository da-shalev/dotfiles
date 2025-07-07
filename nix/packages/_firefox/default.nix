{ pkgs, inputs, ... }: pkgs.firefox_nightly.override (import ./config.nix)
