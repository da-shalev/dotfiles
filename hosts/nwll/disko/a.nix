{
  fileSystems = {
    "/".neededForBoot = true;
    "/persist".neededForBoot = true;
    "/mnt/a".neededForBoot = true;
  };
  rollback = {
    enable = true;
    snapshot = "blank";
    volume = "poodila/faketmpfs";
  };
  disko.devices = {
    disk = {
      poodila = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-WD_BLACK_SN850X_1000GB_243053805786";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              type = "EF00";
              label = "ESP";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            poodila = {
              label = "POODILA";
              size = "100%";
              content = {
                type = "zfs";
                pool = "poodila";
              };
            };
          };
        };
      };
    };
    zpool = {
      poodila = {
        type = "zpool";
        options = {
          autotrim = "off";
          ashift = "12";
        };
        rootFsOptions = {
          compression = "zstd";
          acltype = "posixacl";
          atime = "off";
          xattr = "sa";
          normalization = "formD";
          mountpoint = "none";
          canmount = "off";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "prompt";
          sync = "disabled";
          dnodesize = "auto";
        };
        datasets = {
          faketmpfs = {
            type = "zfs_fs";
            options.mountpoint = "/";
            mountpoint = "/";
          };
          nix = {
            type = "zfs_fs";
            options.mountpoint = "/nix";
            mountpoint = "/nix";
          };
          tmp = {
            type = "zfs_fs";
            options.mountpoint = "/tmp";
            mountpoint = "/tmp";
          };
          persist = {
            type = "zfs_fs";
            options.mountpoint = "/persist";
            mountpoint = "/persist";
          };
          a = {
            type = "zfs_fs";
            options.mountpoint = "/mnt/a";
            mountpoint = "/mnt/a";
          };
          dashalev = {
            type = "zfs_fs";
            options.mountpoint = "/home/dashalev";
            mountpoint = "/home/dashalev";
          };
          reserved = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              reservation = "10G";
            };
          };
        };
        postCreateHook = "zfs snapshot poodila/faketmpfs@blank";
      };
    };
  };
}
