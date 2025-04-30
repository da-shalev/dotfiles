{ config, lib, pkgs, ... }:
let
  bookmarkPaste = pkgs.writeShellScriptBin "bookmark-paste" ''
    pkill wmenu; ${pkgs.wtype}/bin/wtype "$(cat ~/.config/bookmarks | ${config.h.wmenu.pipe}/bin/wmenu)"
  '';

  bookmarkRemove = pkgs.writeShellScriptBin "bookmark-remove" ''
    line=$(tail -n1 ~/.config/bookmarks)
    sed -i '$d' ~/.config/bookmarks
    exec ${pkgs.libnotify}/bin/notify-send "📖 Bookmark Removed" -- "$line"
  '';

  bookmarkAdd = pkgs.writeShellScriptBin "bookmark-add" ''
    ${pkgs.wl-clipboard}/bin/wl-paste >> ~/.config/bookmarks
    exec ${pkgs.libnotify}/bin/notify-send "📖 Bookmark Added" "$(${pkgs.wl-clipboard}/bin/wl-paste)"
  '';

  toggleHdr = pkgs.writeShellScriptBin "toggle-hdr" ''
    hyprctl monitors -j | ${pkgs.jq}/bin/jq -c '.[]' | while read -r mon; do
      name=$(echo "$mon" | ${pkgs.jq}/bin/jq -r '.name')
      width=$(echo "$mon" | ${pkgs.jq}/bin/jq -r '.width')
      height=$(echo "$mon" | ${pkgs.jq}/bin/jq -r '.height')
      refresh=$(echo "$mon" | ${pkgs.jq}/bin/jq -r '.refreshRate' | cut -d'.' -f1)
      x=$(echo "$mon" | ${pkgs.jq}/bin/jq -r '.x')
      y=$(echo "$mon" | ${pkgs.jq}/bin/jq -r '.y')
      scale=$(echo "$mon" | ${pkgs.jq}/bin/jq -r '.scale' | cut -d'.' -f1)
      format=$(echo "$mon" | ${pkgs.jq}/bin/jq -r '.currentFormat')

      config="''${name},''${width}x''${height}@''${refresh},''${x}x''${y},''${scale}"

      case "''${format}" in
        *2101010*)
          hyprctl keyword monitor "''${config}"
          ${pkgs.libnotify}/bin/notify-send "HDR" "Disabled on ''${name}"
          ;;
        *)
          hyprctl keyword monitor "''${config},bitdepth,10,cm,hdr"
          ${pkgs.libnotify}/bin/notify-send "HDR" "Enabled on ''${name}"
          ;;
      esac
    done
  '';

in {
  options.h.hyprland = {
    enable = lib.mkEnableOption "Enables Hyprland WM." // { default = false; };
    mod = lib.mkOption {
      type = lib.types.str;
      default = "SUPER";
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf config.h.hyprland.enable {
    wayland.windowManager.hyprland = let mod = config.h.hyprland.mod;
    in {
      enable = true;
      systemd = {
        enable = true;
        variables = [ "--all" ];
      };
      package = null;
      portalPackage = null;
      extraConfig = "${config.h.hyprland.extraConfig}";
      settings = {
        xwayland = { enabled = true; };
        cursor = { no_hardware_cursors = true; };
        general = {
          gaps_in = 0;
          gaps_out = 0;
          border_size = 0;
          layout = "master";
        };
        master = { mfact = 0.5; };
        decoration = {
          rounding = 0;
          blur = { enabled = false; };
          shadow = { enabled = false; };
        };
        input = {
          repeat_delay = 300;
          repeat_rate = 50;
        };
        misc = {
          # why did I have this enabled?
          # vfr = true;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          background_color = "0x000000";
        };
        render = { cm_fs_passthrough = true; };
        animations = {
          enabled = false;
          first_launch_animation = false;
        };
        experimental = { xx_color_management_v4 = true; };
        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "evdev";
          follow_mouse = 0;
          accel_profile = "flat";
          mouse_refocus = false;
          touchpad = { natural_scroll = true; };
          sensitivity = 0;
        };
        env = [
          "XCURSOR_SIZE,${builtins.toString config.h.wayland.cursorTheme.size}"
        ];
        windowrulev2 = [
          "float, title:^(Picture-in-Picture)$"
          "pin, title:^(Picture-in-Picture)$"
          "move 100%-30% 0, title:^(Picture-in-Picture)$"
          "size 30% 30%, title:^(Picture-in-Picture)$"
        ];
        bind = [
          "${mod}+Shift, Q, exit"
          "${mod}+Shift, 0, pin"
          "${mod}+Shift, H, resizeactive, -50 0"
          "${mod}+Shift, L, resizeactive, 50 0"
          "${mod}+Shift, J, layoutmsg, swapnext"
          "${mod}+Shift, K, layoutmsg, swapprev"
          "${mod}, Return, exec, ${pkgs.foot}/bin/foot"
          "${mod},Q, killactive"
          "${mod},F, fullscreen, 0"
          "${mod},S, togglefloating"
          "${mod},J, layoutmsg, cyclenext"
          "${mod},K, layoutmsg, cycleprev"
          "${mod}+Shift, S, exec, pkill grimshot || ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify copy area"
          "${mod}+Shift, N, exec, pkill gammastep || ${pkgs.gammastep}/bin/gammastep -O 4000"
          "${mod}+Shift, C, exec, pkill hyprpicker || ${pkgs.hyprpicker}/bin/hyprpicker | ${pkgs.wl-clipboard}/bin/wl-copy"
          "${mod},Space, exec, pkill wmenu || ${config.h.wmenu.run}/bin/wmenu-run"
          "${mod}, Z, exec, ${bookmarkPaste}/bin/bookmark-paste"
          "${mod}, X, exec, ${bookmarkAdd}/bin/bookmark-add"
          "${mod}+Shift, X, exec, ${bookmarkRemove}/bin/bookmark-remove"
          "${mod}, F9, exec, ${toggleHdr}/bin/toggle-hdr"
        ] ++ (builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "${mod}, code:1${toString i}, workspace, ${toString ws}"
            "${mod} SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]) 9));
        bindm =
          [ "${mod}, mouse:272, movewindow" "${mod}, mouse:273, resizewindow" ];
        exec-once = [
          # "${pkgs.foot}/bin/foot --server --log-no-syslog"
          "${pkgs.hyprnotify}/bin/hyprnotify"
        ];
        monitor = ",preferred,auto,1";
      };
    };
  };
}
