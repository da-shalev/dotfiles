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
          if [ ! -d ${config.rebuild.path}/.static ]; then
            mkdir -p ${config.rebuild.path}
            cp -a "${self}/." ${config.rebuild.path}
            ${lib.getExe pkgs.sudo} chmod -R gu+rw ${config.rebuild.path}
          fi
        '';
      };

      preservation.preserveAt."/nix/persist" = {
        directories = [ config.rebuild.path ];
      };

      environment = {
        variables.NIXPKGS_CONFIG = lib.mkForce config.rebuild.path;
        systemPackages = [
          (pkgs.writeShellApplication {
            name = "upgrade";
            runtimeInputs = with pkgs; [ custom.sys_notify nixos-rebuild ];
            text = ''
              sys_notify "System upgrade started" -u low
              SECONDS=0

              if nixos-rebuild switch --flake ${config.rebuild.path}/# --sudo; then
                sys_notify "Upgrade complete" "Finished in $SECONDS seconds" -u low
              else
                sys_notify "Upgrade failed" "Failed after $SECONDS seconds" -u critical
              fi
            '';
          })
          (pkgs.writeShellApplication {
            name = "bootgrade";
            runtimeInputs = with pkgs; [ libnotify nixos-rebuild ];
            text = ''
              sys_notify "System bootgrade started" -u low
              SECONDS=0
              if nixos-rebuild boot --flake ${config.rebuild.path}/# --sudo; then
                sys_notify "Bootgrade complete" "Finished in $SECONDS seconds" -u low
              else
                sys_notify "Bootgrade failed" "Failed after $SECONDS seconds" -u critical
              fi
            '';
          })
          (pkgs.writeShellApplication {
            name = "update";
            runtimeInputs = with pkgs; [ libnotify nix ];
            text = ''
              sys_notify "System update started" -u low
              SECONDS=0
              if nix flake update --flake ${config.rebuild.path}; then
                sys_notify "Update complete" "Finished in $SECONDS seconds" -u low
              else
                sys_notify "Update failed" "Failed after $SECONDS seconds" -u critical
              fi
            '';
          })
          (pkgs.writeShellApplication {
            name = "cleanup";
            runtimeInputs = with pkgs; [ libnotify nix ];
            text = ''
              sys_notify "System cleanup started" -u low
              SECONDS=0
              if sudo nix-collect-garbage -d; then
                sys_notify "Cleanup complete" "Finished in $SECONDS seconds" -u low
              else
                sys_notify "Cleanup failed" "Failed after $SECONDS seconds" -u critical
              fi
            '';
          })
        ];
      };
    };
  };
}
