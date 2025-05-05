{ ... }: {
  fileSystems = { "/".neededForBoot = true; };
  disko.devices = {
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [ "size=1G" "defaults" "mode=755" ];
      };
    };
    disk = {
      namesareoverrated = {
        # nveme1n1
        # 512G
        device = "/dev/disk/by-id/nvme-eui.002538b421b78a7d";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            plainSwap = {
              size = "8G";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };
            nix = {
              end = "-10G";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/nix";
                mountOptions = [ "defaults" "pquota" "noatime" ];
              };
            };
          };
        };
      };
    };
  };
}
