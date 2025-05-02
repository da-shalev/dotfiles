{ lib, pkgs, config, ... }: {
  options.h = {
    userName = lib.mkOption { type = with lib.types; nonEmptyStr; };
    path = lib.mkOption {
      type = with lib.types; nonEmptyStr;
      description = "The users $HOME directory.";
    };

    xdgRoot = lib.mkOption {
      type = with lib.types; nonEmptyStr;
      # I perfer a directory for all user-data
      default = "library/";
      description =
        "Root directory for XDG-style configuration under the home directory. Normally set to '.', which results in paths like ~/.config and ~/.local/share.";
    };
    xdg = lib.mkOption {
      type = with lib.types; path;
      default = "/profiles/per-user/${config.h.userName}/etc/xdg";
      description =
        "Path to per user from xdg, can be set to any location always in /etc/";
    };

    # there should be no reason why you want to change these defaults
    dataHome = lib.mkOption {
      type = with lib.types; nonEmptyStr;
      default = "${config.h.path}/${config.h.xdgRoot}/local/share";
    };
    stateHome = lib.mkOption {
      type = with lib.types; nonEmptyStr;
      default = "${config.h.path}/${config.h.xdgRoot}/local/state";
    };
    configHome = lib.mkOption {
      type = with lib.types; nonEmptyStr;
      default = "${config.h.path}/${config.h.xdgRoot}/config";
    };
    cacheHome = lib.mkOption {
      type = with lib.types; nonEmptyStr;
      default = "${config.h.path}/${config.h.xdgRoot}/cache";
    };

    userDirs = lib.mkOption {
      type = with lib.types; attrsOf (with lib.types; str);
      default = { };
      description = "User directory definitions.";
    };
    extraPackages = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
      description = "The packages for the user.";
    };
    shell = {
      package = lib.mkOption {
        type = with lib.types; package;
        default = [ ];
        description = "The default user shell.";
      };

      colour = lib.mkOption { type = with lib.types; nonEmptyStr; };
      icon = lib.mkOption { type = with lib.types; nonEmptyStr; };

      variables = lib.mkOption {
        type = with lib.types; attrsOf anything;
        default = { };
        description = "The session variables for the user.";
      };

      sourceEnv = lib.mkOption {
        type = lib.types.package;
        default = pkgs.writeShellScript "source-env" (lib.concatStringsSep "\n"
          ([ ''[ -n "$__env_sourced" ] && return'' "export __env_sourced=1" ]
            ++ lib.mapAttrsToList
            (name: value: ''export ${name}="${builtins.toString value}"'')
            config.h.shell.variables));
      };

      aliases = lib.mkOption {
        type = with lib.types; attrsOf (with lib.types; str);
        default = { };
        description = "Local user defined aliases.";
      };
    };
  };

  config = let
    usershell = "${config.h.userName}-shell";
    shell = pkgs.runCommand "${usershell}" {
      passthru.shellPath = "/bin/${usershell}";
    } ''
      mkdir -p $out/bin
      echo '#!${lib.getExe pkgs.dash}' > $out/bin/${usershell}
      echo '. ${config.h.shell.sourceEnv}' >> $out/bin/${usershell}
      echo 'exec ${lib.getExe config.h.shell.package}' >> $out/bin/${usershell}
      chmod +x $out/bin/${usershell}
    '';
  in {
    h = {
      userDirs = {
        XDG_DESKTOP_DIR = lib.mkDefault "${config.h.path}/";
        XDG_DOCUMENTS_DIR = lib.mkDefault "${config.h.path}/dox";
        XDG_DOWNLOAD_DIR = lib.mkDefault "${config.h.path}/dow";
        XDG_MUSIC_DIR = lib.mkDefault "${config.h.path}/";
        XDG_PICTURES_DIR = lib.mkDefault "${config.h.path}/pix";
        XDG_PUBLICSHARE_DIR = lib.mkDefault "${config.h.path}/media";
        XDG_TEMPLATES_DIR = lib.mkDefault "${config.h.path}/";
        XDG_VIDEOS_DIR = lib.mkDefault "${config.h.path}/vid";
      };

      # extraPackages = [ config.h.shell.sourceEnv ];

      # non overridable xdg dirs
      shell.variables = config.h.userDirs // {
        XDG_DATA_HOME = lib.mkForce "${config.h.dataHome}";
        XDG_STATE_HOME = lib.mkForce "${config.h.stateHome}";
        XDG_CONFIG_HOME = lib.mkForce "${config.h.configHome}";
        XDG_CACHE_HOME = lib.mkForce "${config.h.cacheHome}";
        XDG_RUNTIME_DIR = lib.mkForce
          "/run/user/${toString config.users.users.${config.h.userName}.uid}";
        SHELL = "${lib.getExe config.h.shell.package}";
      };
    };

    environment.etc."${config.h.xdg}/user-dirs.dirs".text = ''
      ${lib.concatStringsSep "\n"
      (lib.mapAttrsToList (k: v: ''${k}="${v}"'') config.h.userDirs)}
    '';

    users.users.${config.h.userName} = { inherit shell; };
    environment.shells = [ shell ];
  };
}
