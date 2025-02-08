{ config, lib, pkgs, ... }: {
  options.h.river = {
    enable = lib.mkEnableOption "Enables River WM." // { default = false; };
    sandbar = {
      enable = lib.mkEnableOption "Enable sandbar." // { default = true; };
      launch = lib.mkEnableOption "Automagically start it up." // {
        default = false;
      };
      config = lib.mkOption {
        type = lib.types.str;
        default = ''
          -font "monospace:size=24" -active-fg-color "#ffffff" -active-bg-color "#b16286" -title-bg-color "#000000" -inactive-bg-color "#000000"'';
      };
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf config.h.river.enable {
    home.sessionVariables = { XDG_CURRENT_DESKTOP = "river"; };
    wayland.windowManager.river = let mod = "Alt";
    in {
      enable = true;
      package = lib.mkForce pkgs.river_git;
      settings = {
        map.normal = {
          "${mod} Return" = "spawn '${pkgs.foot}/bin/footclient'";
          "${mod} Q" = "close";
          "${mod} F" = "toggle-fullscreen";
          "${mod} S" = "toggle-float";
          "${mod} J" = "focus-view next";
          "${mod} K" = "focus-view previous";
          "${mod}+Shift S" =
            "spawn 'pkill grimshot || ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify copy area | -'";
          "${mod} Space" = "spawn 'pkill fuzzel || ${pkgs.fuzzel}/bin/fuzzel'";
          "${mod}+Shift H" = "swap next";
          "${mod}+Shift J" = "swap previous";
          "${mod}+Shift Q" = "exit";
        } // lib.optionals config.h.river.sandbar.enable {
          "${mod} U" =
            "spawn 'pkill sandbar || ${pkgs.sandbar}/bin/sandbar ${config.h.river.sandbar.config}'";
        };

        map-pointer.normal = {
          "${mod} BTN_LEFT" = "move-view";
          "${mod} BTN_RIGHT" = "resize-view";
        };

        default-layout = "rivertile";
        background-color = "0x000000";
        border-width = 0;
        set-repeat = "50 300";

        spawn = [
          "'${pkgs.foot}/bin/foot --server --log-no-syslog'"
          "'${pkgs.river}/bin/rivertile -view-padding 0 -outer-padding 0 -main-ratio 0.5 -main-location left'"
        ] ++ lib.optionals config.h.river.sandbar.launch [''
          "${pkgs.sandbar}/bin/sandbar ${config.h.river.sandbar.extraConfig}"
        ''];
      };

      extraConfig = ''
        dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=river

        for i in $(seq 1 9)
        do
            tags=$((1 << (i - 1)))
            riverctl map normal ${mod} "$i" set-focused-tags $tags
            riverctl map normal ${mod}+Shift "$i" set-view-tags $tags
            riverctl map normal ${mod}+Control "$i" toggle-focused-tags $tags
            riverctl map normal ${mod}+Shift+Control "$i" toggle-view-tags $tags
        done

        for mouse in $(riverctl list-inputs | grep -i pointer)
        do
          riverctl input $mouse accel-profile flat
        done

        all_tags=$(((1 << 32) - 1))
        riverctl map normal ${mod} 0 set-focused-tags "$all_tags"
        riverctl map normal ${mod}+Shift 0 set-view-tags "$all_tags"

        ${config.h.river.extraConfig}
      '';
    };
  };
}
