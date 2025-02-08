set fish_greeting
set -x fish_prompt_pwd_dir_length 50
history merge

bind --erase --all

fish_vi_key_bindings
fish_config theme choose fishsticks

set -x fish_clear 'clear; commandline -f repaint'

function fzf_cmd
  set -x fzfn (fd . ~ --hidden | fzf)
  if test -z $fzfn
    return
  else if test -d $fzfn
    cd $fzfn
  else
    cd $(dirname $fzfn)
    nvim $(basename $fzfn)
  end

  echo -e ""
  fish_prompt
end
