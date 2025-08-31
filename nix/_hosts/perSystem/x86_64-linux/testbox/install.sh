#!/bin/sh

sudo nix run 'github:nix-community/disko/latest#disko-install' -- --flake $NIXPKGS_CONFIG#testbox --disk main /dev/vda
