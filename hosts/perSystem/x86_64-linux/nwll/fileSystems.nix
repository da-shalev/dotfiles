{
  fileSystems = {
    "/mnt/a" = {
      device = "/dev/disk/by-partlabel/disk-foozilla-gaming";
      fsType = "xfs";
      options = [ "defaults" "nofail" ];
    };

    "/mnt/b" = {
      device = "/dev/disk/by-partlabel/disk-tomatoes-media";
      fsType = "xfs";
      options = [ "defaults" "nofail" ];
    };
  };
}
