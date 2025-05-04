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
