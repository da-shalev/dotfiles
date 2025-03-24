{ config, lib, pkgs, ... }:
let
  bookmarkPaste = pkgs.writeShellScriptBin "bookmark-paste" ''
    pkill wmenu || $(${pkgs.wtype}/bin/wtype "$(cat ~/.config/bookmarks | ${pkgs.wmenu}/bin/wmenu ${config.h.wmenu.config})")
  '';

  bookmarkRemove = pkgs.writeShellScriptBin "bookmark-remove" ''
    line=$(tail -n1 ~/.config/bookmarks)
    sed -i '$d' ~/.config/bookmarks
    ${pkgs.libnotify}/bin/notify-send "📖 Bookmark Removed" -- "$line"
  '';

  bookmarkSet = pkgs.writeShellScriptBin "bookmark-set" ''
    wl-paste >> ~/.config/bookmarks
    ${pkgs.libnotify}/bin/notify-send "📖 Bookmark Set" "$(${pkgs.wl-clipboard}/bin/wl-paste)"
  '';
in {
  options.h.river = {
    enable = lib.mkEnableOption "Enables River WM." // { default = false; };
    mod = lib.mkOption {
      type = lib.types.str;
      default = "Alt";
    };
    sandbar = {
      enable = lib.mkEnableOption "Enable sandbar." // { default = true; };
      launch = lib.mkEnableOption "Automagically start it up." // {
        default = false;
      };
      config = lib.mkOption {
        type = lib.types.str;
        default = ''
          -font "monospace:size=27" -active-fg-color "#ffffff" -active-bg-color "#b16286" -title-bg-color "#000000" -inactive-bg-color "#000000"'';
      };
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf config.h.river.enable {
    home = { sessionVariables = { XDG_CURRENT_DESKTOP = "river"; }; };

    wayland.windowManager.river = let mod = config.h.river.mod;
    in {
      enable = true;
      package = lib.mkForce pkgs.river_git;
      settings = {
        input = {
          "'*'" = {
            accel-profile = "flat";
            pointer-accel = 0;
            disable-while-typing = false;
          };
        };

        map.normal = {
          "${mod} Return" = "spawn ${pkgs.foot}/bin/footclient";
          "${mod} Q" = "close";
          "${mod} F" = "toggle-fullscreen";
          "${mod} S" = "toggle-float";
          "${mod} J" = "focus-view -skip-floating next";
          "${mod} K" = "focus-view -skip-floating previous";
          "${mod}+Shift S" =
            "spawn 'pkill grimshot || ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify copy area | -'";
          "${mod}+Shift H" = "swap next";
          "${mod}+Shift J" = "swap previous";
          "${mod}+Shift Q" = "exit";
          "${mod} N" = "spawn 'pkill gammastep || ${pkgs.gammastep}/bin/gammastep -O 4000'"; 
        } // lib.optionals config.h.river.sandbar.enable {
          "${mod} U" =
            "spawn 'pkill sandbar || ${pkgs.sandbar}/bin/sandbar ${config.h.river.sandbar.config}'";
        } // lib.optionals config.h.wmenu.enable {
          # run an app:
          "${mod} Space" =
            "spawn 'pkill wmenu || ${pkgs.wmenu}/bin/wmenu-run ${config.h.wmenu.config}'";
          # paste a bookmark:
          "${mod} V" = "spawn ${bookmarkPaste}/bin/bookmark-paste";
          # remove a bookmark:
          "${mod}+Shift C" = "spawn ${bookmarkRemove}/bin/bookmark-remove";
          # set a bookmark:
          "${mod} C" = "spawn ${bookmarkSet}/bin/bookmark-set";
        };

        map-pointer.normal = {
          "${mod} BTN_LEFT" = "move-view";
          "${mod} BTN_RIGHT" = "resize-view";
        };

        rule-add = { "-title" = { "Picture-in-Picture" = "float"; }; };

        default-layout = "rivertile";
        background-color = "0x000000";
        border-width = 0;
        set-repeat = "50 300";

        spawn = [
          "'${pkgs.foot}/bin/foot --server --log-no-syslog'"
          "'${pkgs.river}/bin/rivertile -view-padding 0 -outer-padding 0 -main-ratio 0.5 -main-location left'"
        ] ++ lib.optionals config.h.river.sandbar.launch [''
          "${pkgs.sandbar}/bin/sandbar ${config.h.river.sandbar.config}"
        ''];
      };

      extraConfig = ''
        for i in $(seq 1 9)
        do
            tags=$((1 << (i - 1)))
            riverctl map normal ${mod} "$i" set-focused-tags $tags
            riverctl map normal ${mod}+Shift "$i" set-view-tags $tags
            riverctl map normal ${mod}+Control "$i" toggle-focused-tags $tags
            riverctl map normal ${mod}+Shift+Control "$i" toggle-view-tags $tags
        done

        all_tags=$(((1 << 32) - 1))
        riverctl map normal ${mod} 0 set-focused-tags "$all_tags"
        riverctl map normal ${mod}+Shift 0 set-view-tags "$all_tags"

        riverctl xcursor-theme ${config.h.wayland.cursorTheme.name} ${
          builtins.toString config.h.wayland.cursorTheme.size
        }

        ${config.h.river.extraConfig}
      '';
    };
  };
}
