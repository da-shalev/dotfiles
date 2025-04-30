{ config, pkgs, ... }:

{
  environment.systemPackages = if config.programs.nh.enable then [
    (pkgs.writeShellScriptBin "upgrade" ''
      ${pkgs.libnotify}/bin/notify-send "System upgrade started"

      SECONDS=0
      if nh os switch $NIXPKGS_CONFIG; then
        ${pkgs.libnotify}/bin/notify-send "Upgrade complete" "Finished in $SECONDS seconds" -u low
      else
        ${pkgs.libnotify}/bin/notify-send "Upgrade failed" "Failed after $SECONDS seconds" -u critical
      fi
    '')
    (pkgs.writeShellScriptBin "bootgrade" ''
      ${pkgs.libnotify}/bin/notify-send "System bootgrade started"

      SECONDS=0
      if nh os boot $NIXPKGS_CONFIG; then
        ${pkgs.libnotify}/bin/notify-send "Bootgrade complete" "Finished in $SECONDS seconds" -u low
      else
        ${pkgs.libnotify}/bin/notify-send "Bootgrade failed" "Failed after $SECONDS seconds" -u critical
      fi
    '')
    (pkgs.writeShellScriptBin "update" ''
      ${pkgs.libnotify}/bin/notify-send "System update started"

      SECONDS=0
      if nix flake update --flake $NIXPKGS_CONFIG; then
        ${pkgs.libnotify}/bin/notify-send "Update complete" "Finished in $SECONDS seconds" -u low
      else
        ${pkgs.libnotify}/bin/notify-send "Update failed" "Failed after $SECONDS seconds" -u critical
      fi
    '')
    (pkgs.writeShellScriptBin "cleanup" ''
      ${pkgs.libnotify}/bin/notify-send "System cleanup started"

      SECONDS=0
      if nh clean all; then
        ${pkgs.libnotify}/bin/notify-send "Cleanup complete" "Finished in $SECONDS seconds" -u low
        if nix store optimise; then
          ${pkgs.libnotify}/bin/notify-send "Optimized store complete" "Finished in $SECONDS seconds" -u low
        else
          ${pkgs.libnotify}/bin/notify-send "Optimizing store failed" "Failed after $SECONDS seconds" -u critical
        fi
      else
        ${pkgs.libnotify}/bin/notify-send "Cleanup failed" "Failed after $SECONDS seconds" -u critical
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
