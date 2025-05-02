{ config, inputs, lib, pkgs, ... }:
let
  bookmarkPaste = pkgs.writeShellScriptBin "bookmark-paste" ''
    pkill wmenu; ${
      lib.getExe pkgs.wtype
    } "$(cat ${config.h.configHome}/bookmarks | 
      ${pkgs.wmenu}/bin/wmenu
    )"
  '';

  bookmarkRemove = pkgs.writeShellScriptBin "bookmark-remove" ''
    line=$(tail -n1 ${config.h.configHome}/bookmarks)
    sed -i '$d' ${config.h.configHome}/bookmarks
    exec ${lib.getExe pkgs.libnotify} "📖 Bookmark Removed" -- "$line"
  '';

  bookmarkAdd = pkgs.writeShellScriptBin "bookmark-add" ''
    ${pkgs.wl-clipboard}/bin/wl-paste >> ${config.h.configHome}/bookmarks
    exec ${
      lib.getExe pkgs.libnotify
    } "📖 Bookmark Added" "$(${pkgs.wl-clipboard}/bin/wl-paste)"
  '';

  toggleHdr = pkgs.writeShellScriptBin "toggle-hdr" ''
    hyprctl monitors -j | ${lib.getExe pkgs.jq} -c '.[]' | while read -r mon; do
      name=$(echo "$mon" | ${lib.getExe pkgs.jq} -r '.name')
      width=$(echo "$mon" | ${lib.getExe pkgs.jq} -r '.width')
      height=$(echo "$mon" | ${lib.getExe pkgs.jq} -r '.height')
      refresh=$(echo "$mon" | ${
        lib.getExe pkgs.jq
      } -r '.refreshRate' | cut -d'.' -f1)
      x=$(echo "$mon" | ${lib.getExe pkgs.jq} -r '.x')
      y=$(echo "$mon" | ${lib.getExe pkgs.jq} -r '.y')
      scale=$(echo "$mon" | ${lib.getExe pkgs.jq} -r '.scale' | cut -d'.' -f1)
      format=$(echo "$mon" | ${lib.getExe pkgs.jq} -r '.currentFormat')

      config="''${name},''${width}x''${height}@''${refresh},''${x}x''${y},''${scale}"

      case "''${format}" in
        *2101010*)
          hyprctl keyword monitor "''${config}"
          ${lib.getExe pkgs.libnotify} "HDR" "Disabled on ''${name}"
          ;;
        *)
          hyprctl keyword monitor "''${config},bitdepth,10,cm,hdr"
          ${lib.getExe pkgs.libnotify} "HDR" "Enabled on ''${name}"
          ;;
      esac
    done
  '';
in {
  options.h.hyprland = {
    enable = lib.mkEnableOption "Enables hyprland WM." // { default = false; };
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
    h.extraPackages = with pkgs; [ hyprland ];

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config = { hyprland.default = [ "hyprland" "gtk" ]; };
    };

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };

    environment.etc."${config.h.xdg}/hypr/hyprland.conf" =
      let mod = config.h.hyprland.mod;
      in {
        text = ''
          animations {
            enabled=false
            first_launch_animation=false
          }

          cursor {
            no_hardware_cursors=true
          }

          decoration {
            blur {
              enabled=false
            }

            shadow {
              enabled=false
            }
            rounding=0
          }

          experimental {
            xx_color_management_v4=true
          }

          general {
            border_size=0
            gaps_in=0
            gaps_out=0
            layout=master
          }

          input {
            touchpad {
              natural_scroll=true
            }
            accel_profile=flat
            follow_mouse=0
            kb_layout=us
            kb_model=
            kb_options=
            kb_rules=evdev
            kb_variant=
            mouse_refocus=false
            repeat_delay=300
            repeat_rate=50
            sensitivity=0
          }

          master {
            mfact=0.500000
          }

          misc {
            background_color=0x000000
            disable_hyprland_logo=true
            disable_splash_rendering=true
          }

          render {
            cm_fs_passthrough=true
          }

          xwayland {
            enabled=true
          }

          bind=${mod}+Shift, Q, exit
          bind=${mod}+Shift, 0, pin
          bind=${mod}+Shift, H, resizeactive, -50 0
          bind=${mod}+Shift, L, resizeactive, 50 0
          bind=${mod}+Shift, J, layoutmsg, swapnext
          bind=${mod}+Shift, K, layoutmsg, swapprev
          bind=${mod}, Return, exec, ${lib.getExe pkgs.foot}
          bind=${mod}, Q, killactive
          bind=${mod}, F, fullscreen, 0
          bind=${mod}, S, togglefloating
          bind=${mod}, J, layoutmsg, cyclenext
          bind=${mod}, K, layoutmsg, cycleprev
          bind=${mod}+Shift, S, exec, pkill grimshot || ${
            lib.getExe pkgs.sway-contrib.grimshot
          } --notify copy area
          bind=${mod}+Shift, N, exec, pkill gammastep || ${
            lib.getExe pkgs.gammastep
          } -O 4000
          bind=${mod}+Shift, C, exec, pkill hyprpicker || ${
            lib.getExe pkgs.hyprpicker
          } | ${pkgs.wl-clipboard}/bin/wl-copy
          bind=${mod}, Space, exec, pkill wmenu || ${pkgs.wmenu}/bin/wmenu-run
          bind=${mod}, Z, exec, ${lib.getExe bookmarkPaste}
          bind=${mod}, X, exec, ${lib.getExe bookmarkAdd}
          bind=${mod}+Shift, X, exec, ${lib.getExe bookmarkRemove}
          bind=${mod}, F9, exec, ${lib.getExe toggleHdr}

          bind=${mod}, code:10, workspace, 1
          bind=${mod} SHIFT, code:10, movetoworkspace, 1
          bind=${mod}, code:11, workspace, 2
          bind=${mod} SHIFT, code:11, movetoworkspace, 2
          bind=${mod}, code:12, workspace, 3
          bind=${mod} SHIFT, code:12, movetoworkspace, 3
          bind=${mod}, code:13, workspace, 4
          bind=${mod} SHIFT, code:13, movetoworkspace, 4
          bind=${mod}, code:14, workspace, 5
          bind=${mod} SHIFT, code:14, movetoworkspace, 5
          bind=${mod}, code:15, workspace, 6
          bind=${mod} SHIFT, code:15, movetoworkspace, 6
          bind=${mod}, code:16, workspace, 7
          bind=${mod} SHIFT, code:16, movetoworkspace, 7
          bind=${mod}, code:17, workspace, 8
          bind=${mod} SHIFT, code:17, movetoworkspace, 8
          bind=${mod}, code:18, workspace, 9
          bind=${mod} SHIFT, code:18, movetoworkspace, 9
          bindm=${mod}, mouse:272, movewindow
          bindm=${mod}, mouse:273, resizewindow

          exec-once=${lib.getExe pkgs.hyprnotify}
          windowrulev2=float, title:^(Picture-in-Picture)$
          windowrulev2=pin, title:^(Picture-in-Picture)$
          windowrulev2=move 100%-30% 0, title:^(Picture-in-Picture)$
          windowrulev2=size 30% 30%, title:^(Picture-in-Picture)$

          ${config.h.hyprland.extraConfig}
        '';
      };
  };
}
