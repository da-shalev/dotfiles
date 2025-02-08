{ config, lib, pkgs, ... }: {
  options.h.fish = {
    enable = lib.mkEnableOption
      "Enables the fish shell. Fish should be enabled globally for this to work correctly." // {
        default = true;
      };
  };

  config = lib.mkIf config.h.fish.enable {
    xdg.configFile = {
      "fish/themes/fishsticks.theme".source = ./fishsticks.theme;
    };

    programs.fish = {
      enable = true;
      shellInit = builtins.readFile ./config.fish;
      interactiveShellInit = builtins.readFile ./map.fish;
      functions = {
        fish_mode_prompt = {
          body = "";
          onEvent = null;
        };

        fish_prompt = {
          body = ''
            printf '%s%s%s %s%s%s\n%s ' \
              (set_color ${config.h.shell.colour})(whoami)\
              (set_color "brwhite")@\
              (set_color "bryellow")(hostname)\
              (set_color "brgreen") (prompt_pwd) \
              (set_color "brred"; fish_git_prompt) \
              (set_color normal)${config.h.shell.icon}
          '';
          onEvent = null;
        };
      };

      plugins = [
        {
          name = "autopair";
          inherit (pkgs.fishPlugins.autopair) src;
        }
        {
          name = "puffer";
          inherit (pkgs.fishPlugins.puffer) src;
        }
      ];
    };
  };
}
