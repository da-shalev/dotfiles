{ self, lib, ... }:
let
  compootuers =
    lib.modules.importApply ./_compootuers.nix { localFlake = self; };
in {
  inherit (compootuers) imports;
  flake = {
    modules.flake = { inherit compootuers; };
    compootuers = {
      perSystem = ../../_hosts/perSystem;
      allSystems = ../../_hosts/allSystems;
      perArch = ../../_hosts/perArch;
    };
  };
}
