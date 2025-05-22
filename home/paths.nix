{ lib, pkgs, config, ... }: {
  options.h = {
    userName = lib.mkOption { type = with lib.types; nonEmptyStr; };
    path = lib.mkOption {
      type = with lib.types; nonEmptyStr;
      default = config.users.users.${config.h.userName}.home;
      description = "The users home location.";
    };

    profile = {
      # nixos sources these by default
      path = lib.mkOption {
        type = with lib.types; path;
        default = "/users/per-user/${config.h.userName}";
        description =
          "Filesystem path for the per-user profile. Do not use '/etc/profiles' as it is reserved for NixOS profiles.";
        readOnly = true;
      };
      config = lib.mkOption {
        type = with lib.types; path;
        default = "${config.h.profile.path}/config";
        description = "Profile config path";
      };
      data = lib.mkOption {
        type = with lib.types; path;
        default = "${config.h.profile.path}/share";
        description = "Profile data path";
      };
    };

    xdg = {
      userDirs = lib.mkOption {
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

      configFiles = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            text = lib.mkOption {
              type = lib.types.nullOr lib.types.lines;
              default = null;
            };
            source = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              default = null;
            };
          };
        });
        default = { };
      };

      dataFiles = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            text = lib.mkOption {
              type = lib.types.nullOr lib.types.lines;
              default = null;
            };
            source = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              default = null;
            };
          };
        });
        default = { };
      };

      # currently does not support customization
      root = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = ".";
        description =
          "Root directory for XDG-style configuration under the home directory. Defaults to '.', which results in paths like ~/.config and ~/.local/share.";
        readOnly = true;
      };
      localHome = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = "${config.h.path}/${config.h.xdg.root}local";
        readOnly = true;
      };
      dataHome = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = "${config.h.xdg.localHome}/share";
        readOnly = true;
      };
      stateHome = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = "${config.h.xdg.localHome}/state";
        readOnly = true;
      };
      configHome = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = "${config.h.path}/${config.h.xdg.root}config";
        readOnly = true;
      };
      cacheHome = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = "${config.h.path}/${config.h.xdg.root}cache";
        readOnly = true;
      };
    };

    packages = lib.mkOption {
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

      sourceEnv = lib.mkOption {
        type = lib.types.package;
        default = pkgs.writeShellScriptBin "source-env" ''
          ${lib.concatStringsSep "\n" (lib.mapAttrsToList
            (name: value: ''export ${name}="${builtins.toString value}"'')
            config.h.shell.variables)}

          ${lib.optionalString config.h.wayland.enable ''
            ${lib.concatStringsSep "\n" (lib.mapAttrsToList
              (key: val: ''${lib.getExe pkgs.dconf} write ${key} "'${val}'"'')
              config.h.wayland.dconf)}
          ''}
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
    createUserDirs = lib.concatStringsSep "\n" (lib.mapAttrsToList (_: path:
      "install -d -o ${config.h.userName} -g ${
        config.users.users.${config.h.userName}.group
      } ${lib.escapeShellArg path}") config.h.xdg.userDirs);
    createXdgDirs = lib.concatStringsSep "\n" (builtins.map (path:
      "install -d -o ${config.h.userName} -g ${
        config.users.users.${config.h.userName}.group
      } ${lib.escapeShellArg path}") config.h.xdg.dirs);
  in {
    # share profile configuration on rebuild
    system.activationScripts."z-config-${config.h.userName}".text = ''
      cp -rf "/etc${config.h.profile.config}"/. "${config.h.xdg.configHome}"
      chown -R "${userperm}" "${config.h.xdg.configHome}"
      cp -rf "/etc${config.h.profile.data}"/. "${config.h.xdg.dataHome}"
      chown -R "${userperm}" "${config.h.xdg.dataHome}"

      ${createUserDirs}
      ${createXdgDirs}
    '';

    h = {
      # non overridable xdg dirs
      shell = {
        paths = [ "${config.h.xdg.localHome}/bin" ];
        variables = config.h.xdg.userDirs // {
          XDG_DATA_HOME = lib.mkForce "${config.h.xdg.dataHome}";
          XDG_STATE_HOME = lib.mkForce "${config.h.xdg.stateHome}";
          XDG_CONFIG_HOME = lib.mkForce "${config.h.xdg.configHome}";
          XDG_CACHE_HOME = lib.mkForce "${config.h.xdg.cacheHome}";
          SHELL = "${lib.getExe config.h.shell.package}";
          PATH = lib.concatStringsSep ":" (config.h.shell.paths ++ [ "$PATH" ]);
        };
      };

      packages = [ config.h.shell.sourceEnv ];

      xdg = {
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

        configFiles = {
          "user-dirs.dirs".text = ''
            ${lib.concatStringsSep "\n"
            (lib.mapAttrsToList (k: v: ''${k}="${v}"'') config.h.xdg.userDirs)}
          '';
          "user-dirs.conf".text = ''
            enabled=False
          '';
        };
      };
    };

    environment = {
      localBinInPath = lib.mkForce false;
      etc = let
        makeEntries = prefix: files:
          lib.mapAttrs' (name: cfg:
            lib.nameValuePair "${prefix}/${name}" (if cfg.source != null then {
              source = cfg.source;
            } else if cfg.text != null then {
              text = cfg.text;
            } else
              throw
              "Invalid entry '${name}': must define either 'source' or 'text'"))
          files;
      in makeEntries config.h.profile.config config.h.xdg.configFiles
      // makeEntries config.h.profile.data config.h.xdg.dataFiles;
    };

    users.users.${config.h.userName} = {
      shell = config.h.shell.package;
      packages = config.h.packages;
      isNormalUser = true;
    };
  };
}
