{ config, pkgs, lib, ... }:

{
  environment.systemPackages = if config.programs.nh.enable then [
    (pkgs.writeShellScriptBin "upgrade" ''
      ${lib.getExe pkgs.libnotify} "System upgrade started"

      SECONDS=0
      if nh os switch $NIXPKGS_CONFIG; then
        ${
          lib.getExe pkgs.libnotify
        } "Upgrade complete" "Finished in $SECONDS seconds" -u low
      else
        ${
          lib.getExe pkgs.libnotify
        } "Upgrade failed" "Failed after $SECONDS seconds" -u critical
      fi
    '')
    (pkgs.writeShellScriptBin "bootgrade" ''
      ${lib.getExe pkgs.libnotify} "System bootgrade started"

      SECONDS=0
      if nh os boot $NIXPKGS_CONFIG; then
        ${
          lib.getExe pkgs.libnotify
        } "Bootgrade complete" "Finished in $SECONDS seconds" -u low
      else
        ${
          lib.getExe pkgs.libnotify
        } "Bootgrade failed" "Failed after $SECONDS seconds" -u critical
      fi
    '')
    (pkgs.writeShellScriptBin "update" ''
      ${lib.getExe pkgs.libnotify} "System update started"

      SECONDS=0
      if nix flake update --flake $NIXPKGS_CONFIG; then
        ${
          lib.getExe pkgs.libnotify
        } "Update complete" "Finished in $SECONDS seconds" -u low
      else
        ${
          lib.getExe pkgs.libnotify
        } "Update failed" "Failed after $SECONDS seconds" -u critical
      fi
    '')
    (pkgs.writeShellScriptBin "cleanup" ''
      ${lib.getExe pkgs.libnotify} "System cleanup started"

      SECONDS=0
      if nh clean all; then
        ${
          lib.getExe pkgs.libnotify
        } "Cleanup complete" "Finished in $SECONDS seconds" -u low
        if nix store optimise; then
          ${
            lib.getExe pkgs.libnotify
          } "Optimized store complete" "Finished in $SECONDS seconds" -u low
        else
          ${
            lib.getExe pkgs.libnotify
          } "Optimizing store failed" "Failed after $SECONDS seconds" -u critical
        fi
      else
        ${
          lib.getExe pkgs.libnotify
        } "Cleanup failed" "Failed after $SECONDS seconds" -u critical
      fi
    '')
  ] else [
    (pkgs.writeShellScriptBin "upgrade" ''
      sudo nixos-rebuild switch --flake $NIXPKGS_CONFIG#${config.systemGenesis.hostName}
    '')
    (pkgs.writeShellScriptBin "bootgrade" ''
      sudo nixos-rebuild boot --flake $NIXPKGS_CONFIG#${config.systemGenesis.hostName}
    '')
    (pkgs.writeShellScriptBin "update" ''
      nix flake update --flake $NIXPKGS_CONFIG
    '')
    (pkgs.writeShellScriptBin "cleanup" ''
      nix-collect-garbage -d
      nix store optimise
    '')
  ];
}
