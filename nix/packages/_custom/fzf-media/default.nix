{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "fzf-media";
  runtimeInputs = with pkgs; [ fd fzf gnused coreutils ];
  text = ''
    fzfn=$(
      fd . ~/media /mnt/*/media --hidden |
      # split output into raw path - and filtered paths without /media/
      sed 's|.*|&\t&|; s|\t.*\/media\/|\t|' |
      # sort by the filtered paths only
      sort --key=2 -t/ |
      fzf --delimiter='\t' --with-nth=2 |
      cut -f1
    )

    if [ -z "$fzfn" ]; then
      exit 1
    elif [ -d "$fzfn" ]; then
      echo "$fzfn"
    else
      dirname "$fzfn"
    fi
  '';
}
