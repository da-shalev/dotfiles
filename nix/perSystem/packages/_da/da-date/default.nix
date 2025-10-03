{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "da-date";
  runtimeInputs = with pkgs; [ coreutils ];
  text = ''
    echo "⌚  $(date '+%b %d')"
  '';
}
