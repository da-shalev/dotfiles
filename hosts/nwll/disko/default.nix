{
  imports = [ ./a.nix ./b.nix ];

  systemGenesis.rootIsTmpfs = true;

  fileSystems."/mnt/a" = {
    device = "/dev/disk/by-partlabel/disk-foozilla-gaming";
    fsType = "xfs";
    options = [ "defaults" "nofail" ];
  };

  fileSystems."/mnt/b" = {
    device = "/dev/disk/by-partlabel/disk-tomatoes-media";
    fsType = "xfs";
    options = [ "defaults" "nofail" ];
  };
}
