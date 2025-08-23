{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "sys_notify";
  runtimeInputs = with pkgs; [ libnotify ];
  text = ''
    [ "$TERM" != "linux" ] && notify-send "$@"

    if pgrep -x "pipewire" > /dev/null; then
      urgency="normal"

      for ((i=1; i<=$#; i++)); do
        [[ ''${!i} == "-u" ]] && { j=$((i+1)); urgency=''${!j}; break; }
      done

      case "$urgency" in
        normal) pw-play ${./warn.flac} ;;
        critical) pw-play ${./critical.flac} ;;
        low) pw-play ${./info.flac} ;;
      esac
    fi
  '';
}
