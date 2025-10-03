{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.compootuers.modules.flake.default
    inputs.treefmt-nix.flakeModule
  ];
}
