{ moduleWithSystem, ... }:
{
  flake.modules.maid.dashalev = moduleWithSystem (
    { pkgs, ... }:
    {
      config,
      lib,
      ...
    }:
    let
      toggleBitdepth = pkgs.writeShellApplication {
        name = "toggle-bitdepth";
        runtimeInputs = with pkgs; [
          hyprland
          jq
          libnotify
        ];
        text = ''
          hyprctl monitors -j | jq -c '.[]' | while read -r mon; do
            name=$(echo "$mon" | jq -r '.name')
            width=$(echo "$mon" | jq -r '.width')
            height=$(echo "$mon" | jq -r '.height')
            refresh=$(echo "$mon" | jq -r '.refreshRate' | cut -d'.' -f1)
            x=$(echo "$mon" | jq -r '.x')
            y=$(echo "$mon" | jq -r '.y')
            scale=$(echo "$mon" | jq -r '.scale' | cut -d'.' -f1)
            format=$(echo "$mon" | jq -r '.currentFormat')
            config="''${name},''${width}x''${height}@''${refresh},''${x}x''${y},''${scale}"
            case "''${format}" in
              *2101010*)
                hyprctl keyword monitor "''${config}"
                notify-send -a "System" "HDR bitdepth 10" "Disabled on ''${name}"
                ;;
              *)
                hyprctl keyword monitor "''${config},bitdepth,10"
                notify-send -a "System" "HDR bitdepth 10" "Enabled on ''${name}"
                ;;
            esac
          done
        '';
      };
    in
    {
      hyprland.config = ''
        ${builtins.readFile ./hyprland.conf}

        bind=$mod, Return, exec, ${lib.getExe' pkgs.foot "footclient"} -D ~/media
        bind=$mod+Shift, S, exec, ${lib.getExe pkgs.hyprshot} -m region --clipboard-only
        bind=$mod+Shift, N, exec, pkill hyprsunset || ${lib.getExe pkgs.hyprsunset} -t 4000
        bind=$mod+Shift, C, exec, pkill hyprpicker || ${lib.getExe pkgs.hyprpicker} | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}
        bind=$mod, Space, exec, pkill wmenu || ${lib.getExe' pkgs.da.wmenu "wmenu-run"}
        bind=$mod, Z, exec, ${lib.getExe pkgs.da.bookmark-paste}
        bind=$mod, F9, exec, ${lib.getExe toggleBitdepth}

        exec-once=${lib.getExe pkgs.fnott}
        exec-once=${lib.getExe pkgs.foot} --server --log-no-syslog

        bind = , XF86AudioPlay, exec, ${lib.getExe pkgs.mpc} toggle
        bind = , XF86AudioPrev, exec, ${lib.getExe pkgs.mpc} prev
        bind = , XF86AudioNext, exec, ${lib.getExe pkgs.mpc} next
      '';
    }
  );
}
