{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "fzf-media";
  runtimeInputs = [ pkgs.fd pkgs.fzf pkgs.gnused pkgs.coreutils ];
  text = ''
    fzfn=$(
      fd . ~/media /mnt/*/media "$NIXPKGS_CONFIG" --hidden |
      # split output into raw path - and filtered paths without /media/
      sed 's|^\(.*\)$|\1\t\1|; s|\t\(.*\)\/media\/|\t|' |
      fzf --with-nth=2 \
        --bind 'ctrl-o:execute(test -f {1} && xdg-open {1})+accept' \
        --bind 'ctrl-e:execute(nvim {1})+abort' |
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
