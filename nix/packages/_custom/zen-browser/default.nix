{ inputs', pkgs, ... }:
pkgs.wrapFirefox inputs'.zen-browser.packages.zen-browser-unwrapped
(import ./config.nix)
