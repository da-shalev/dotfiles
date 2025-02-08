{ lib, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    home.stateVersion = lib.mkForce "24.05";
  };
}
