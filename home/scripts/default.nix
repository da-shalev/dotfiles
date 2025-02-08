{ pkgs, ... }: {
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "yonk";

      runtimeInputs = [ git ];

      text = ''
        git clone --recurse-submodules "git@github.com:$1.git"
      '';
    })

    (writeShellApplication {
      name = "yt-mp3";
      runtimeInputs = [ yt-dlp ];

      text = ''
        yt-dlp --audio-quality 0 --extract-audio --audio-format mp3 "$1"
      '';
    })
  ];
}
