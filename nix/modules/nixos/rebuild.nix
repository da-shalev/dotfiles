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
            sudo chmod -R gu+rw ${config.rebuild.path}
          fi
        '';
      };

      environment = {
        persistence."/nix/persist".directories = [ config.rebuild.path ];
        variables.NIXPKGS_CONFIG = lib.mkForce config.rebuild.path;
        systemPackages = [
          (pkgs.writeShellApplication {
            name = "upgrade";
            runtimeInputs = with pkgs; [ libnotify nixos-rebuild ];
            text = ''
              notify-send "System upgrade started"
              SECONDS=0
              if nixos-rebuild switch --flake ${config.rebuild.path}/# --sudo; then
                notify-send "Upgrade complete" "Finished in $SECONDS seconds" -u low
              else
                notify-send "Upgrade failed" "Failed after $SECONDS seconds" -u critical
              fi
            '';
          })
          (pkgs.writeShellApplication {
            name = "bootgrade";
            runtimeInputs = with pkgs; [ libnotify nixos-rebuild ];
            text = ''
              notify-send "System bootgrade started"
              SECONDS=0
              if nixos-rebuild boot --flake ${config.rebuild.path}/# --sudo; then
                notify-send "Bootgrade complete" "Finished in $SECONDS seconds" -u low
              else
                notify-send "Bootgrade failed" "Failed after $SECONDS seconds" -u critical
              fi
            '';
          })
          (pkgs.writeShellApplication {
            name = "update";
            runtimeInputs = with pkgs; [ libnotify nix ];
            text = ''
              notify-send "System update started"
              SECONDS=0
              if nix flake update --flake ${config.rebuild.path}; then
                notify-send "Update complete" "Finished in $SECONDS seconds" -u low
              else
                notify-send "Update failed" "Failed after $SECONDS seconds" -u critical
              fi
            '';
          })
          (pkgs.writeShellApplication {
            name = "cleanup";
            runtimeInputs = with pkgs; [ libnotify nix ];
            text = ''
              notify-send "System cleanup started"
              SECONDS=0
              if sudo nix-collect-garbage -d; then
                notify-send "Cleanup complete" "Finished in $SECONDS seconds" -u low
              else
                notify-send "Cleanup failed" "Failed after $SECONDS seconds" -u critical
              fi
            '';
          })
        ];
      };
    };
  };
}
