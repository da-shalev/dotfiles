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

      owner = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
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
          if [ ! -f ${config.rebuild.path}/.static ]; then
            mkdir -p ${config.rebuild.path}
            cp -a "${self}/." ${config.rebuild.path}
            ${lib.getExe pkgs.sudo} chmod -R gu+rw ${config.rebuild.path}
            ${lib.optionalString (config.rebuild.owner or null != null) ''
              ${lib.getExe pkgs.sudo} chown -R ${config.rebuild.owner}:users ${config.rebuild.path}
            ''}
          fi
        '';
      };

      preservation.preserveAt."/nix/persist" = {
        directories = [
          ({
            directory = config.rebuild.path;
          } // lib.optionalAttrs (config.rebuild.owner != null) {
            user = config.rebuild.owner;
            group = "users";
          })
        ];
      };

      environment = {
        variables.NIXPKGS_CONFIG = lib.mkForce config.rebuild.path;
        systemPackages = [
          (pkgs.writeShellApplication {
            name = "upgrade";
            runtimeInputs = with pkgs; [ libnotify nixos-rebuild ];
            text = ''
              [ "$TERM" != "linux" ] && notify-send -a "System" "Upgrade started" -u normal
              SECONDS=0

              if nixos-rebuild switch --flake ${config.rebuild.path}/# --sudo; then
                [ "$TERM" != "linux" ] && notify-send -a "System" "Upgrade complete" "Finished in $SECONDS seconds" -u normal
              else
                [ "$TERM" != "linux" ] && notify-send -a "System" "Upgrade failed" "Failed after $SECONDS seconds" -u critical
              fi
            '';
          })
          (pkgs.writeShellApplication {
            name = "bootgrade";
            runtimeInputs = with pkgs; [ libnotify nixos-rebuild ];
            text = ''
              [ "$TERM" != "linux" ] && notify-send -a "System" "Bootgrade started" -u normal
              SECONDS=0
              if nixos-rebuild boot --flake ${config.rebuild.path}/# --sudo; then
                [ "$TERM" != "linux" ] && notify-send -a "System" "Bootgrade complete" "Finished in $SECONDS seconds" -u normal
              else
                [ "$TERM" != "linux" ] && notify-send -a "System" "Bootgrade failed" "Failed after $SECONDS seconds" -u critical
              fi
            '';
          })
          (pkgs.writeShellApplication {
            name = "update";
            runtimeInputs = with pkgs; [ libnotify nix ];
            text = ''
              [ "$TERM" != "linux" ] && notify-send -a "System" "Update started" -u normal
              SECONDS=0
              if nix flake update --flake ${config.rebuild.path}; then
                [ "$TERM" != "linux" ] && notify-send -a "System" "Update complete" "Finished in $SECONDS seconds" -u normal
              else
                [ "$TERM" != "linux" ] && notify-send -a "System" "Update failed" "Failed after $SECONDS seconds" -u critical
              fi
            '';
          })
          (pkgs.writeShellApplication {
            name = "cleanup";
            runtimeInputs = with pkgs; [ libnotify nix ];
            text = ''
              [ "$TERM" != "linux" ] && notify-send -a "System" "Cleanup started" -u normal
              SECONDS=0
              if sudo nix-collect-garbage -d; then
                [ "$TERM" != "linux" ] && notify-send -a "System" "Cleanup complete" "Finished in $SECONDS seconds" -u normal
              else
                [ "$TERM" != "linux" ] && notify-send -a "System" "Cleanup failed" "Failed after $SECONDS seconds" -u critical
              fi
            '';
          })
        ];
      };
    };
  };
}
