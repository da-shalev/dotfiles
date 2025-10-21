{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.compootuers.flakeModule
    inputs.treefmt-nix.flakeModule
  ];
}
