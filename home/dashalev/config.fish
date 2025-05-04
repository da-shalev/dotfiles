set fish_greeting
set -x fish_prompt_pwd_dir_length 50
bind --erase --all
history merge

fish_vi_key_bindings
fish_config theme choose fishsticks

bind -M default \cf fzf_cmd
bind -M insert \cf fzf_cmd
bind -M visual \cf fzf_cmd

bind -M insert \cl ''
bind -M visual \cl ''
bind -M default \cl ''

set -x fish_clear 'clear; commandline -f repaint'
bind -M insert \cs $fish_clear
bind -M visual \cs $fish_clear
bind -M default \cs $fish_clear

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

function fish_mode_prompt
end
