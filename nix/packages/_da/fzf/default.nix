{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "fzf";
  runtimeInputs = with pkgs; [ fd fzf gnused coreutils ];
  text = ''
    fzfn=$(fd | sort -t/ | fzf --delimiter='\t' | cut -f1)

    if [ -z "$fzfn" ]; then
      exit 1
    elif [ -d "$fzfn" ]; then
      echo "$fzfn"
    else
      dirname "$fzfn"
    fi
  '';
}
