{
  pname,
  version,
  src,
  meta,
  appimageTools,
  makeWrapper,
}: let
  extracted = appimageTools.extractType2 {
    inherit pname src version;
  };
in
  appimageTools.wrapType2 {
    inherit pname version src meta;

    # extraInstallCommands = ''
    #   source '${makeWrapper}/nix-support/setup-hook'
    #
    #   install -m 444 -D '${extracted}/${pname}.desktop' -t $out/share/applications
    #   substituteInPlace $out/share/applications/${pname}.desktop \
    #     --replace 'Exec=Cider' 'Exec=${pname} ${commandLineArgs}'
    # '';

    multiArch = false;
    extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
  }
