{
  flake.modules.maid.shell = { lib, config, pkgs, ... }: {
    options = {
      shell = {
        package = lib.mkOption {
          type = with lib.types; package;
          default = [ ];
          description = "The default user shell.";
        };

        colour = lib.mkOption { type = with lib.types; nonEmptyStr; };
        icon = lib.mkOption { type = with lib.types; nonEmptyStr; };

        # NOTE: sources env and ensures important dirs exist, only runs on log in
        source_env = lib.mkOption {
          type = lib.types.package;
          default = pkgs.writeShellScriptBin "source-env" ''
            ${lib.concatStringsSep "\n" (lib.mapAttrsToList
              (name: value: ''export ${name}="${builtins.toString value}"'')
              config.shell.variables)}
            ${lib.concatStringsSep "\n" (lib.mapAttrsToList
              (name: path: "mkdir -p ${builtins.toString path}")
              config.user_dirs)}
            ${lib.concatStringsSep "\n"
            (map (path: "mkdir -p ${builtins.toString path}") config.dirs)}
          '';
        };

        paths = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "List of paths to prepend to PATH";
        };

        variables = lib.mkOption {
          type = with lib.types; attrsOf anything;
          default = { };
          description = "The session variables for the user.";
        };

        aliases = lib.mkOption {
          type = with lib.types; attrsOf (with lib.types; str);
          default = { };
          description = "Local user defined aliases.";
        };
      };

      user_dirs = lib.mkOption {
        type = with lib.types; attrsOf (with lib.types; str);
        default = { };
        description = "User directory definitions.";
      };

      dirs = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        description =
          "List of non-standard directories to create for tools that don't fully follow the XDG specification, like Wine.";
      };
    };

    config = {
      packages = [ config.shell.source_env ];
      # non overridable xdg dirs
      shell = {
        variables = config.user_dirs // {
          XDG_DATA_HOME = "$HOME/.local/share";
          XDG_STATE_HOME = "$HOME/.local/state";
          XDG_CONFIG_HOME = "$HOME/.config";
          XDG_CACHE_HOME = "$HOME/.cache";
          # canada btw
          SHELL_COLOUR = "${config.shell.colour}";
          SHELL_ICON = "${config.shell.icon}";
          PATH = lib.concatStringsSep ":" (config.shell.paths ++ [ "$PATH" ]);
        };
      };

      file.xdg_config = {
        "user-dirs.dirs".text = ''
          ${lib.concatStringsSep "\n"
          (lib.mapAttrsToList (k: v: ''${k}="${v}"'') config.user_dirs)}
        '';
        "user-dirs.conf".text = ''
          enabled=False
        '';
      };
    };
  };
}
