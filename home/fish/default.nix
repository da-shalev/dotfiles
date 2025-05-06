{ config, pkgs, lib, ... }: {
  options.h.fish = {
    enable = lib.mkEnableOption
      "Enables the fish shell. Fish should be enabled globally for this to work correctly."
      // {
        default = false;
      };
    plugins = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ pkgs.fishPlugins.puffer pkgs.fishPlugins.autopair ];
      description = "Define the fish plugins you want to use.";
    };
    interactive = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };

    themes = lib.mkOption {
      type = with lib.types;
        listOf (submodule {
          options = {
            name = lib.mkOption {
              type = str;
              description = "Name to be used for the theme path.";
            };
            source = lib.mkOption {
              type = path;
              description = "Path to the theme file.";
            };
          };
        });
      default = [ ];
      description = "List of theme files with names and sources.";
    };
  };

  config = lib.mkIf config.h.fish.enable {
    programs.fish.enable = true;
    h.xdg.configFiles = let
      fishAliases = lib.concatStringsSep "\n"
        (lib.mapAttrsToList (name: value: "alias ${name} '${value}'")
          config.h.shell.aliases);
      plugins = ''
        ${lib.concatMapStringsSep "\n\n" (plugin: ''
          load_plugin_dir ${plugin.src}
        '') config.h.fish.plugins}
      '';
    in ((builtins.listToAttrs (map (theme: {
      name = "fish/themes/${theme.name}.theme";
      value = { source = theme.source; };
    }) config.h.fish.themes))) // {
      "fish/config.fish".text = ''
        status --is-login; and begin
          source "${lib.getExe config.h.shell.sourceEnv}"
          # fish leftovers -- cache actually at ~/.local/cache
          rm -rf ~/.cache
        end

        status is-interactive; and begin
          ${config.h.fish.interactive}
          ${fishAliases}

          function load_plugin_dir
            set -l plugin_dir $argv[1]
            for dir in functions completions conf.d
              if test -d $plugin_dir/$dir
                set fish_function_path $plugin_dir/functions $fish_function_path
                set fish_complete_path $plugin_dir/completions $fish_complete_path
              end
            end

            for script in $plugin_dir/conf.d/*.fish
              source $script
            end

            for file in init.fish key_bindings.fish
              if test -f $plugin_dir/$file
                source $plugin_dir/$file
              end
            end
          end

          ${plugins}
        end

        ${config.h.fish.extraConfig}
      '';
    };
  };
}
