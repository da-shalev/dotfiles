{ pkgs, ... }: {
  wrappers.wmenu = {
    basePackage = pkgs.wmenu;
    prependFlags =
      [ "-f" "monospace 24" "-s" "#ffffff" "-S" "#b16286" "-N" "#000000" ];
  };
}
