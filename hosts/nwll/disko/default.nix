{
  imports = [ ./a.nix ];

  fileSystems."/mnt/b" = {
    device = "/dev/disk/by-partlabel/disk-foozilla-gaming";
    fsType = "xfs";
    options = [ "defaults" "nofail" ];
  };

  fileSystems."/mnt/c" = {
    device = "/dev/disk/by-partlabel/disk-tomatoes-media";
    fsType = "xfs";
    options = [ "defaults" "nofail" ];
  };
}
