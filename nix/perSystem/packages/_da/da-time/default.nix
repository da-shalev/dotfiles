{ pkgs, ... }:
(pkgs.writeShellApplication {
  name = "da-time";
  runtimeInputs = with pkgs; [ coreutils ];
  text = ''
    [ "$(date +%H)" -lt 12 ] && emoji='🌙' || emoji='☀️'
    echo "$emoji  $(date '+%H:%M')"
  '';
})
