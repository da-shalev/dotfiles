{ inputs, pkgs, ... }:
pkgs.wrapFirefox
inputs.zen-browser.packages.${pkgs.system}.zen-browser-unwrapped
(import ./config.nix)
