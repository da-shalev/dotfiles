{ config, pkgs, lib, ... }: {
  options.h.rebuild = {
    enable = lib.mkEnableOption "Enables convenient rebuild shorthands." // {
      default = false;
    };
  };

  config = lib.mkIf config.h.rebuild.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
    };

    h.packages = [
      (pkgs.writeShellScriptBin "upgrade" ''
        ${lib.getExe pkgs.libnotify} "System upgrade started"

        SECONDS=0
        if nh os switch ${config.systemGenesis.configPath}; then
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
        if nh os boot ${config.systemGenesis.configPath}; then
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
        if nix flake update --flake ${config.systemGenesis.configPath}; then
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
    ];
  };
}
