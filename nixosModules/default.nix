{
  flake.nixosModules = {
    systemGenesis = import ./systemGenesis;
    # darwin = import ./darwin;
    linux = import ./linux;
  };
}
