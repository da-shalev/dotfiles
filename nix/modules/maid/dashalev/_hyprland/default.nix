{ lib, pkgs, ... }:
let
  menu = {
    config = "-f 'monospace 24' -s '#ffffff' -S '#b16286' -N '#000000'";
    pipe = (pkgs.writeShellScriptBin "wmenu" ''
      exec ${lib.getExe' pkgs.wmenu "wmenu"} ${menu.config}
    '');

    run = (pkgs.writeShellScriptBin "wmenu-run" ''
      exec ${lib.getExe' pkgs.wmenu "wmenu-run"} ${menu.config}
    '');
  };

  bookmarkPaste = pkgs.writeShellScriptBin "bookmark-paste" ''
    pkill wmenu; ${lib.getExe pkgs.wtype} "$(cat $XDG_CONFIG_HOME/bookmarks | ${
      lib.getExe menu.pipe
    })"'';

  toggleBitdepth = pkgs.writeShellScriptBin "toggle-bitdepth" ''
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
          ${lib.getExe pkgs.libnotify} "HDR bitdepth 10" "Disabled on ''${name}"
          ;;
        *)
          hyprctl keyword monitor "''${config},bitdepth,10"
          ${lib.getExe pkgs.libnotify} "HDR bitdepth 10" "Enabled on ''${name}"
          ;;
      esac
    done
  '';
in {
  # hyprland.config = ''
  #   ${builtins.readFile ./hyprland.conf}
  #
  #   bind=$mod, Return, exec, uwsm app -- ${lib.getExe' pkgs.foot "footclient"}
  #   bind=$mod+Shift, S, exec, uwsm app -- ${
  #     lib.getExe pkgs.hyprshot
  #   } -m region --clipboard-only
  #   bind=$mod+Shift, N, exec, uwsm app -- pkill hyprsunset || ${
  #     lib.getExe pkgs.hyprsunset
  #   } -t 4000
  #   bind=$mod+Shift, C, exec, uwsm app -- pkill hyprpicker || ${
  #     lib.getExe pkgs.hyprpicker
  #   } | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}
  #   bind=$mod, Space, exec, uwsm app -- pkill wmenu || ${lib.getExe menu.run}
  #   bind=$mod, Z, exec, uwsm app -- ${lib.getExe bookmarkPaste}
  #   bind=$mod, F9, exec, uwsm app -- ${lib.getExe toggleBitdepth}
  #
  #   exec-once=uwsm app -- ${lib.getExe pkgs.mako}
  #   exec-once=uwsm app -- ${lib.getExe pkgs.foot} --server --log-no-syslog
  # '';

  hyprland.config = ''
    ${builtins.readFile ./hyprland.conf}

    bind=$mod, Return, exec, ${lib.getExe' pkgs.foot "footclient"}
    bind=$mod+Shift, S, exec, ${
      lib.getExe pkgs.hyprshot
    } -m region --clipboard-only
    bind=$mod+Shift, N, exec, pkill hyprsunset || ${
      lib.getExe pkgs.hyprsunset
    } -t 4000
    bind=$mod+Shift, C, exec, pkill hyprpicker || ${
      lib.getExe pkgs.hyprpicker
    } | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}
    bind=$mod, Space, exec, pkill wmenu || ${lib.getExe menu.run}
    bind=$mod, Z, exec, ${lib.getExe bookmarkPaste}
    bind=$mod, F9, exec, ${lib.getExe toggleBitdepth}

    exec-once=${lib.getExe pkgs.mako}
    exec-once=${lib.getExe pkgs.foot} --server --log-no-syslog
  '';
}
