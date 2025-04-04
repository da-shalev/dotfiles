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
        xwayland = { force_zero_scaling = true; };
        general = {
          gaps_in = 0;
          gaps_out = 0;
          border_size = 0;
          layout = "master";
          allow_tearing = true;
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
          vfr = true;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          background_color = "0x000000";
        };
        animations = {
          enabled = false;
          first_launch_animation = false;
        };
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
          "${mod}+Shift, 0, pin"
          "${mod}+Shift, H, resizeactive, -50 0"
          "${mod}+Shift, L, resizeactive, 50 0"
          "${mod}+Shift, J, layoutmsg, swapnext"
          "${mod}+Shift, K, layoutmsg, swapprev"
          "${mod}, Return, exec, ${pkgs.foot}/bin/footclient"
          "${mod},Q, killactive"
          "${mod},F, fullscreen, 0"
          "${mod},S, togglefloating"
          "${mod},J, layoutmsg, cyclenext"
          "${mod},K, layoutmsg, cycleprev"
          "${mod}+Shift, S, exec, pkill grimshot || ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify copy area"
          "${mod}+Shift, Q, exit"
          "${mod}, N, exec, pkill gammastep || ${pkgs.gammastep}/bin/gammastep -O 4000"
          "${mod},Space, exec, pkill wmenu || ${pkgs.wmenu}/bin/wmenu-run"
          "${mod}, V, exec, ${bookmarkPaste}/bin/bookmark-paste"
          "${mod}+Shift, C, exec, ${bookmarkRemove}/bin/bookmark-remove"
          "${mod}, C, exec, ${bookmarkSet}/bin/bookmark-set"
        ] ++ (builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "${mod}, code:1${toString i}, workspace, ${toString ws}"
            "${mod} SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]) 9));
        bindm =
          [ "${mod}, mouse:272, movewindow" "${mod}, mouse:273, resizewindow" ];
        exec-once = [ "${pkgs.foot}/bin/foot --server --log-no-syslog" ];
        monitor = ",preferred,auto,1";
      };
    };
  };
}
