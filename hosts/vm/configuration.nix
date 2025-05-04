{ packages, ... }: {
  users.users.test = {
    uid = 1001;
    extraGroups = [ "wheel" "video" "networkmanager" ];
    initialPassword = "boobs";
  };

  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "25.05";
  virtualisation.vmVariantWithBootLoader.virtualisation = {
    memorySize = 8192;
    cores = 4;
    forwardPorts = [{
      from = "host";
      host.port = 2222;
      guest.port = 22;
    }];
  };
}
