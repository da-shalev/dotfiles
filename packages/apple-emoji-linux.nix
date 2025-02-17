{ stdenvNoCC, lib, inputs, ... }:

stdenvNoCC.mkDerivation rec {
  pname = "apple-emoji-linux";
  dontUnpack = true;
  version = "v17.4";

  src = inputs.apple-emoji-linux;

  installPhase = ''
    install -Dm644 $src -t $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "Apple Color Emoji for Linux";
    longDescription =
      "AppleColorEmoji.ttf from Samuel Ng's apple-emoji-linux, release version ${version}, packaged for Nix.";
    homepage = "https://github.com/samuelngs/apple-emoji-linux";
    license = licenses.wtfpl;
    platforms = platforms.unix;
  };
}
