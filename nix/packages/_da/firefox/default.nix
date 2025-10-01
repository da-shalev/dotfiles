{ pkgs, ... }: pkgs.wrapFirefox pkgs.firefox-unwrapped (import ./config.nix)
