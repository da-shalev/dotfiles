{ pkgs, lib, self', ... }:
pkgs.writeShellScriptBin "bookmark-paste" ''
  touch ~/media/bookmarks
  pkill wmenu; ${lib.getExe pkgs.wtype} "$(cat ~/media/bookmarks | ${
    lib.getExe' self'.packages.wmenu "wmenu"
  })"''
