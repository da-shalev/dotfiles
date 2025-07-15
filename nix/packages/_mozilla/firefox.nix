{ pkgs, ... }: pkgs.firefox_nightly.override (import ./config.nix)
