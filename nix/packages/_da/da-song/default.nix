{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "da-song";
  runtimeInputs = with pkgs; [ mpc ];
  text = ''
    mpc current 2>/dev/null | awk -v len="''${1:-100}" '{
      if (length > len) {
        s = substr($0, 1, len)
        gsub(/ +$/, "", s)
        print "🎵   " s "..."
      } else 
        print "🎵   " $0
    }' || echo ""
  '';
}
