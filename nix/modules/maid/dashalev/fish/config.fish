set fish_greeting
set -x fish_prompt_pwd_dir_length 50
bind --erase --all
history merge

function fish_vi_cursor
end

function fish_mode_prompt
end

fish_vi_key_bindings
fish_config theme choose fishsticks

bind -M default \cf fzf_cmd
bind -M insert \cf fzf_cmd
bind -M visual \cf fzf_cmd

function clear
  command clear
  repaint
end

function repaint
  commandline -f repaint
end

bind -M default \cg 'tms; repaint'
bind -M insert \cg 'tms; repaint'
bind -M visual \cg 'tms; repaint'

bind -M insert \cs 'clear'
bind -M visual \cs 'clear'
bind -M default \cs 'clear'

function fzf_cmd
  set target (fzf-media)
  if test -n "$target"
    cd "$target"
  end

  clear
end

function fish_prompt
  printf '%s%s%s %s%s%s\n%s ' \
    (set_color "$SHELL_COLOR")(whoami) \
    (set_color "brwhite")@ \
    (set_color "bryellow")(hostname) \
    (set_color "brgreen") (prompt_pwd) \
    (set_color "brred"; fish_git_prompt) \
    $SHELL_ICON
end
