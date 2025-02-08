# ZFS-based impermanence but instead of rolling back on every start, roll back on safe shutdown/halt/reboot.
{ config, lib, pkgs, ... }:

let
  cfg = config.rollback;
  cfgZfs = config.boot.zfs;
in {
  options = with lib; {
    rollback = {
      enable =
        mkEnableOption "Impermanence on safe-shutdown through ZFS snapshots";

      volume = mkOption {
        type = types.str;
        default = null;
        example = "zroot/ROOT/empty";
        description = ''
          Full description to the volume including pool.
          This volume must have a snapshot to an "empty" state.

          WARNING: The volume will be rolled back to the snapshot on every safe-shutdown.
        '';
      };

      snapshot = mkOption {
        type = types.str;
        default = null;
        example = "start";
        description = ''
          Snapshot of the volume in an "empty" state to roll back to.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      tmp.cleanOnBoot = true;
      zfs.package = lib.mkOverride 99 pkgs.zfs_cachyos;
      kernelPackages = pkgs.linuxPackages_cachyos;
      kernelParams = [ "zfs.zfs_arc_max=12884901888" "usbcore.autosuspend=-1" ];
    };

    networking.hostId = lib.mkForce "218670ce";

    systemd.shutdownRamfs.contents."/etc/systemd/system-shutdown/zpool".source =
      lib.mkForce (pkgs.writeShellScript "zpool-sync-shutdown" ''
        ${cfgZfs.package}/bin/zfs rollback -r "${cfg.volume}@${cfg.snapshot}"
        exec ${cfgZfs.package}/bin/zpool sync
      '');
    systemd.shutdownRamfs.storePaths = [ "${cfgZfs.package}/bin/zfs" ];
  };
}
