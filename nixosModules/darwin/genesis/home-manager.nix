{ lib, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [{
      home.stateVersion = lib.mkForce "24.05";
    }];
  };
}
