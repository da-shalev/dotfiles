#!/bin/sh

fzfn=$(
  fd . ~/media /mnt/*/media "$NIXPKGS_CONFIG" --hidden |
  sed 's|^\(.*\)$|\1\t\1|; s|\t\(.*\)\/media\/|\t|' |
  fzf --with-nth=2 \
    --bind 'ctrl-o:execute(test -f {1} && xdg-open {1})+accept' \
    --bind 'ctrl-e:execute(nvim {1})+abort' |
  cut -f1
)

if [ -z "$fzfn" ]; then
  exit 1
elif [ -d "$fzfn" ]; then
  cd "$fzfn"
else
  cd "$(dirname "$fzfn")" 
fi

exit 1
