{ config, lib, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "old";
    verbose = true;
    sharedModules = [{
      home.stateVersion = lib.mkForce config.system.stateVersion;
      nix.package = lib.mkForce config.nix.package;
    }];
  };
}
