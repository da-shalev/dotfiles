{ self, ... }: {
  flake.modules.nixos.rebuild = { lib, config, pkgs, ... }: {
    options.rebuild = {
      dir = lib.mkOption {
        type = lib.types.str;
        description =
          "Path in /etc/ to the flake-based NIXPKGS_CONFIG directory, usually '/etc/nixos'";
        default = "nixos";
      };

      path = lib.mkOption {
        type = lib.types.path;
        readOnly = true;
        default = "/etc/${config.rebuild.dir}";
      };
    };

    config = {
      # regenerates dotfiles if deleted
      systemd.services.setup-dotfiles = {
        description = "Setup dotfiles directory";
        wantedBy = [ "multi-user.target" ];
        after = [ "local-fs.target" "systemd-sysusers.service" ];
        serviceConfig = { Type = "oneshot"; };
        script = ''
          if [ ! -d ${config.rebuild.path} ]; then
            mkdir -p ${config.rebuild.path}
            cp -a "${self}/." ${config.rebuild.path}
          fi
        '';
      };

      environment = {
        persistence."/nix/persist".directories = [ config.rebuild.path ];
        variables.NIXPKGS_CONFIG = lib.mkOverride 3 config.rebuild.path;
        systemPackages = [
          (pkgs.writeShellScriptBin "upgrade" ''
            ${lib.getExe pkgs.libnotify} "System upgrade started"

            SECONDS=0
            if nixos-rebuild switch --flake ${config.rebuild.path}/# --sudo; then
              ${
                lib.getExe pkgs.libnotify
              } "Upgrade complete" "Finished in $SECONDS seconds" -u low
            else
              ${
                lib.getExe pkgs.libnotify
              } "Upgrade failed" "Failed after $SECONDS seconds" -u critical
            fi
          '')
          (pkgs.writeShellScriptBin "bootgrade" ''
            ${lib.getExe pkgs.libnotify} "System bootgrade started"

            SECONDS=0
            if nixos-rebuild boot --flake ${config.rebuild.path}/# --sudo; then
              ${
                lib.getExe pkgs.libnotify
              } "Bootgrade complete" "Finished in $SECONDS seconds" -u low
            else
              ${
                lib.getExe pkgs.libnotify
              } "Bootgrade failed" "Failed after $SECONDS seconds" -u critical
            fi
          '')
          (pkgs.writeShellScriptBin "update" ''
            ${lib.getExe pkgs.libnotify} "System update started"

            SECONDS=0
            if nix flake update --flake ${config.rebuild.path}; then
              ${
                lib.getExe pkgs.libnotify
              } "Update complete" "Finished in $SECONDS seconds" -u low
            else
              ${
                lib.getExe pkgs.libnotify
              } "Update failed" "Failed after $SECONDS seconds" -u critical
            fi
          '')
          (pkgs.writeShellScriptBin "cleanup" ''
            ${lib.getExe pkgs.libnotify} "System cleanup started"

            SECONDS=0
            if sudo nix-collect-garbage -d; then
              ${
                lib.getExe pkgs.libnotify
              } "Cleanup complete" "Finished in $SECONDS seconds" -u low
            else
              ${
                lib.getExe pkgs.libnotify
              } "Cleanup failed" "Failed after $SECONDS seconds" -u critical
            fi
          '')
        ];
      };
    };
  };
}
