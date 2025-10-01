{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.compootuers.modules.flake.default
    inputs.treefmt-nix.flakeModule
  ];

  flake.compootuers = {
    perSystem = ../../_hosts/perSystem;
    allSystems = ../../_hosts/allSystems;
    perArch = ../../_hosts/perArch;
  };
}
