{ inputs, ... }: {
  imports = [ inputs.mcsimw.modules.flake.compootuers ];
  flake.compootuers = {
    perSystem = ../../_hosts/perSystem;
    allSystems = ../../_hosts/allSystems;
    perArch = ../../_hosts/perArch;
  };
}
