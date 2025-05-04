{ lib, pkgs, config, ... }: {
  options.h = {
    userName = lib.mkOption { type = with lib.types; nonEmptyStr; };
    path = lib.mkOption {
      type = with lib.types; nonEmptyStr;
      description = "The users $HOME directory.";
    };

    profile = {
      # nixos sources these by default
      path = lib.mkOption {
        type = with lib.types; path;
        default = "/profiles/per-user/${config.h.userName}";
        readOnly = true;
        description = "Profile path to per user";
      };
      config = lib.mkOption {
        type = with lib.types; path;
        default = "${config.h.profile.path}/etc/xdg";
        readOnly = true;
        description = "Profile config path";
      };
      data = lib.mkOption {
        type = with lib.types; path;
        default = "${config.h.profile.path}/share";
        readOnly = true;
        description = "Profile data path";
      };
    };

    xdg = {
      root = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = ".";
        description =
          "Root directory for XDG-style configuration under the home directory. Defaults to '.', which results in paths like ~/.config and ~/.local/share.";
      };
      dataHome = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = "${config.h.path}/${config.h.xdg.root}local/share";
      };
      stateHome = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = "${config.h.path}/${config.h.xdg.root}local/state";
      };
      configHome = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = "${config.h.path}/${config.h.xdg.root}config";
      };
      cacheHome = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = "${config.h.path}/${config.h.xdg.root}cache";
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
        default = pkgs.writeShellScriptBin "source-env" ''
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
    userperm =
      "${config.h.userName}:${config.users.users.${config.h.userName}.group}";
    createUserDirs = lib.concatStringsSep "\n" (lib.mapAttrsToList (name: path:
      "mkdir -p ${lib.escapeShellArg path} && chown -R ${userperm} ${
        lib.escapeShellArg path
      }") config.h.xdg.userDirs);
  in {
    # share xdg on rebuild
    system.activationScripts."z-config-${config.h.userName}".text = ''
      if [ -d "${config.h.path}" ]; then
        cp -rf "/etc/${config.h.profile.config}" "${config.h.xdg.configHome}"
        chown -R "${userperm}" "${config.h.xdg.configHome}"

        ${createUserDirs}
      fi
    '';

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
      "${config.h.profile.config}/user-dirs.dirs".text = ''
        ${lib.concatStringsSep "\n"
        (lib.mapAttrsToList (k: v: ''${k}="${v}"'') config.h.xdg.userDirs)}
      '';
      "${config.h.profile.config}/user-dirs.conf".text = ''
        enabled=False
      '';
    };

    users.users.${config.h.userName} = {
      shell = config.h.shell.package;
      isNormalUser = true;
      packages = config.h.extraPackages;
    };
  };
}
