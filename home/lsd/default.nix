{ config, pkgs, lib, ... }: {
  options.h.lsd = {
    enable = lib.mkEnableOption "Enable lsd." // { default = true; };
  };

  config = lib.mkIf config.h.lsd.enable {
    h.extraPackages = with pkgs; [ lsd ];
    environment.etc."${config.h.profile.config}/lsd/config.yaml".text = ''
      blocks:
      - permission
      - user
      - group
      - date
      - name
      classic: false
      date: +%b %d
      dereference: false
      display: almost-all
      header: false
      hyperlink: never
      ignore-globs:
      - '**/.DS_Store'
      indicators: false
      layout: grid
      no-symlink: false
      permission: rwx
      size: short
      sorting:
        column: name
        dir-grouping: first
        reverse: false
      symlink-arrow: '⇒ '
      total-size: false
    '';
  };
}
