{ inputs, ... }: {
  imports = [ inputs.mcsimw.modules.flake.compootuers ];
  compootuers = {
    perSystem = ../../_hosts/perSystem;
    allSystems = ../../_hosts/allSystems;
  };
}
