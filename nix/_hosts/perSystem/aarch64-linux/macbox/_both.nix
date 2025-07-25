{
  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    # spice-webdavd.enable = true;
  };

  security.sudo.wheelNeedsPassword = false;

  fileSystems."/mnt/a" = {
    device = "share";
    fsType = "9p";
    options = [ "no-fail" "trans=virtio" "rw" ];
  };
}
