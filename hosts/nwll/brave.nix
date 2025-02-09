{ pkgs, ... }:

let
  brave = pkgs.writeShellScriptBin "brave" ''
    mkdir -p ~/.local/share/brave
    HOME=~/.local/share/brave ${pkgs.brave}/bin/brave --ozone-platform-hint=auto \
      --enable-features=UseOzonePlatform,CanvasOopRasterization,ParallelDownloading,WebRTCPipeWireCapturer,WaylandWindowDecorations \
      --ignore-gpu-blocklist \
      --ozone-platform-hint=auto
  '';
in { environment.systemPackages = [ brave ]; }
