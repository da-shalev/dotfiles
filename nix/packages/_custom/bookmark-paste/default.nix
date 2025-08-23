{ pkgs, lib, ... }:
pkgs.writeShellScriptBin "bookmark-paste" ''
  touch ~/media/bookmarks
  pkill wmenu; ${lib.getExe pkgs.wtype} "$(cat ~/media/bookmarks | ${
    lib.getExe' pkgs.custom.wmenu "wmenu"
  })"''
