{ lib, pkgs, config, ... }: {
  options.h = {
    userName = lib.mkOption { type = with lib.types; nonEmptyStr; };
    path = lib.mkOption {
      type = with lib.types; nonEmptyStr;
      description = "The users $HOME directory.";
    };

    xdg = {
      root = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = ".";
        description =
          "Root directory for XDG-style configuration under the home directory. Defaults to '.', which results in paths like ~/.config and ~/.local/share.";
      };
      path = lib.mkOption {
        type = with lib.types; path;
        default = "/profiles/per-user/${config.h.userName}/etc/xdg";
        description =
          "Path to per user from xdg, can be set to any location always in /etc/";
      };
      dataHome = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = "${config.h.path}/${config.h.xdg.root}/local/share";
      };
      stateHome = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = "${config.h.path}/${config.h.xdg.root}/local/state";
      };
      configHome = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = "${config.h.path}/${config.h.xdg.root}/config";
      };
      cacheHome = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = "${config.h.path}/${config.h.xdg.root}/cache";
      };
      userDirs = lib.mkOption {
        type = with lib.types; attrsOf (with lib.types; str);
        default = { };
        description = "User directory definitions.";
      };
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
        default = pkgs.writeShellScript "source-env" ''
          [ -n "$__env_sourced" ] && return
          export __env_sourced=1
          ${lib.concatStringsSep "\n" (lib.mapAttrsToList
            (name: value: ''export ${name}="${builtins.toString value}"'')
            config.h.shell.variables)}
        '';
      };

      aliases = lib.mkOption {
        type = with lib.types; attrsOf (with lib.types; str);
        default = { };
        description = "Local user defined aliases.";
      };
    };
  };

  config = let
    userShell = "${config.h.userName}-shell";
    shell = pkgs.runCommand "${userShell}" {
      passthru.shellPath = "/bin/${userShell}";
    } ''
      mkdir -p $out/bin
      echo '#!${lib.getExe pkgs.dash}' > $out/bin/${userShell}
      echo '. ${config.h.shell.sourceEnv}' >> $out/bin/${userShell}
      echo 'exec ${lib.getExe config.h.shell.package}' >> $out/bin/${userShell}
      chmod +x $out/bin/${userShell}
    '';

    userDirs = lib.concatStringsSep "\n"
      (lib.mapAttrsToList (name: path: "mkdir -p ${lib.escapeShellArg path}")
        config.h.xdg.userDirs);

    shareXdg = ''
      if [ -d "${config.h.path}" ]; then
        mkdir -p "${config.h.xdg.configHome}"
        cp -rf /etc/${config.h.xdg.path}/. "${config.h.xdg.configHome}/"
        ${userDirs}
      fi
    '';
  in {
    # share xdg on rebuild
    system.activationScripts."config-${config.h.userName}".text = shareXdg;

    # on first boot, the /etc/profiles/per-user/ xdg cfg needs to be copied over as well
    systemd.services."config-${config.h.userName}" = {
      description = "XDG-ifcation";
      after = [ "multi-user.target" ];
      serviceConfig = {
        # Environment = [
        #   "XDG_CONFIG_HOME=${config.h.xdg.configHome}"
        #   "HOME=${config.h.path}"
        # ];
        ConditionFirstBoot = "yes";
        Type = "oneshot";
        User = config.h.userName;
        ExecStart = "${pkgs.writeShellScript "xdg" ''
          ${shareXdg}
        ''}";
      };
      wantedBy = [ "multi-user.target" ];
    };

    h = {
      xdg.userDirs = {
        XDG_DESKTOP_DIR = lib.mkDefault "${config.h.path}/";
        XDG_DOCUMENTS_DIR = lib.mkDefault "${config.h.path}/dox";
        XDG_DOWNLOAD_DIR = lib.mkDefault "${config.h.path}/dow";
        XDG_MUSIC_DIR = lib.mkDefault "${config.h.path}/";
        XDG_PICTURES_DIR = lib.mkDefault "${config.h.path}/pix";
        XDG_PUBLICSHARE_DIR = lib.mkDefault "${config.h.path}/media";
        XDG_TEMPLATES_DIR = lib.mkDefault "${config.h.path}/";
        XDG_VIDEOS_DIR = lib.mkDefault "${config.h.path}/vid";
      };

      # non overridable xdg dirs
      shell.variables = config.h.xdg.userDirs // {
        XDG_DATA_HOME = lib.mkForce "${config.h.xdg.dataHome}";
        XDG_STATE_HOME = lib.mkForce "${config.h.xdg.stateHome}";
        XDG_CONFIG_HOME = lib.mkForce "${config.h.xdg.configHome}";
        XDG_CACHE_HOME = lib.mkForce "${config.h.xdg.cacheHome}";
        SHELL = "${lib.getExe config.h.shell.package}";
        CUDA_CACHE_PATH = "${config.h.xdg.cacheHome}/nv";
        GNUPGHOME = "${config.h.xdg.dataHome}/gnupg";
      };
    };

    environment.etc = {
      "${config.h.xdg.path}/user-dirs.dirs".text = ''
        ${lib.concatStringsSep "\n"
        (lib.mapAttrsToList (k: v: ''${k}="${v}"'') config.h.xdg.userDirs)}
      '';
      "${config.h.xdg.path}/user-dirs.conf".text = ''
        enabled=False
      '';
    };

    users.users.${config.h.userName} = {
      inherit shell;
      packages = config.h.extraPackages;
      name = "${config.h.userName}";
      home = "${config.h.path}";
      isNormalUser = true;
    };

    environment.shells = [ shell ];
  };
}
