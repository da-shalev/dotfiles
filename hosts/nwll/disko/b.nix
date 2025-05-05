{ ... }: {
  disko.devices = {
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [ "size=1G" "defaults" "mode=755" ];
      };
    };
    disk = {
      rollwithit = {
        # nveme0n1
        # 1TB
        device = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b405e1623";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            home = {
              end = "-10G";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/home";
                mountOptions = [ "defaults" "pquota" "noatime" ];
              };
            };
          };
        };
      };
    };
  };
}
