{ config, pkgs, lib, ... }: {
  options.h.fish = {
    enable = lib.mkEnableOption
      "Enables the fish shell. Fish should be enabled globally for this to work correctly."
      // {
        default = true;
      };
    plugins = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ pkgs.fishPlugins.puffer pkgs.fishPlugins.autopair ];
      description = "Define the fish plugins you want to use.";
    };
  };

  config = lib.mkIf config.h.fish.enable {
    programs.fish.enable = true;
    environment.etc = let
      fishAliases = lib.concatStringsSep "\n"
        (lib.mapAttrsToList (name: value: "alias ${name} '${value}'")
          config.h.shell.aliases);
      plugins = ''
        ${lib.concatMapStringsSep "\n\n" (plugin: ''
          set -l plugin_dir ${plugin.src}

          if test -d $plugin_dir/functions
              set fish_function_path $fish_function_path[1] $plugin_dir/functions $fish_function_path[2..-1]
          end

          if test -d $plugin_dir/completions
              set fish_complete_path $fish_complete_path[1] $plugin_dir/completions $fish_complete_path[2..-1]
          end

          if test -d $plugin_dir/conf.d
              for f in $plugin_dir/conf.d/*.fish
                  source $f
              end
          end

          if test -f $plugin_dir/key_bindings.fish
              source $plugin_dir/key_bindings.fish
          end

          if test -f $plugin_dir/init.fish
              source $plugin_dir/init.fish
          end
        '') config.h.fish.plugins}
      '';
    in {
      "${config.h.profile.config}/fish/themes/fishsticks.theme".source =
        ./fishsticks.theme;
      "${config.h.profile.config}/fish/config.fish".text = ''
        set -q __fish_sourced; and exit
        set -g __fish_sourced 1

        source "${lib.getExe config.h.shell.sourceEnv}"

        status is-interactive; and begin
          set fish_greeting
          set -x fish_prompt_pwd_dir_length 50
          bind --erase --all
          history merge
          fish_vi_key_bindings
          fish_config theme choose fishsticks

          ${fishAliases}

          function fzf_cmd
            set -x fzfn (${lib.getExe pkgs.fd} . ~ --hidden | ${
              lib.getExe pkgs.fzf
            })
            if test -z $fzfn
              return
            else if test -d $fzfn
              cd $fzfn
            else
              cd $(dirname $fzfn)
              nvim $(basename $fzfn)
            end

            echo -e ""
            fish_prompt
          end

          function fish_mode_prompt
          end

          function fish_prompt
            printf '%s%s%s %s%s%s\n%s ' \
              (set_color "${config.h.shell.colour}")(whoami) \
              (set_color "brwhite")@ \
              (set_color "bryellow")(hostname) \
              (set_color "brgreen") (prompt_pwd) \
              (set_color "brred"; fish_git_prompt) \
              ${config.h.shell.icon}
          end

          ${plugins}
        end
      '';
    };
  };
}
