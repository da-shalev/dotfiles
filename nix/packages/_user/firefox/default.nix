{ pkgs, ... }:
pkgs.wrapFirefox pkgs.firefox-unwrapped
(import ../mozilla-config.nix)
