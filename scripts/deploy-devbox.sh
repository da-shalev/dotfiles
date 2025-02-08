#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "IP address of remote system not specified"
  exit 1
fi

read -p "have you ran: 'sudo nixos-generate-config --no-filesystems --dir /mnt' on the remote system (y or N): " response

if [[ ! "$response" =~ ^[Yy]$ ]]; then
  echo "Please run 'sudo nixos-generate-config --no-filesystems --dir /mnt' on the remote system before proceeding."
  exit 1
fi

 nix run github:nix-community/nixos-anywhere -- --flake .#notflix --target-host nixos@$1
