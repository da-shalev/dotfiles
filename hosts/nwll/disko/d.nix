{
  disko.devices = {
    disk = {
      tomatoes = {
        # sda
        # 2TB
        device = "/dev/disk/by-id/usb-OWC_Express_1M2_2405264800A6-0:0";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            media = {
              start = "0";
              end = "-10G";
              content = {
                type = "filesystem";
                format = "xfs";
              };
            };
          };
        };
      };
    };
  };
}
