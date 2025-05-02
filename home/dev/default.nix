{ config, pkgs, lib, ... }: {
  options.h.dev = {
    enable = lib.mkEnableOption "Enable generic development tools." // {
      default = true;
    };
  };

  config = lib.mkIf config.h.dev.enable {
    xdg = {
      configFile = {
        # I love npm
        "npm/config".text = ''
          cache=${config.h.cacheHome}/npm
        '';
      };
    };

    home = {
      sessionVariables = with pkgs; {
        GOPATH = "${config.h.dataHome}/go";
        NPM_CONFIG_PREFIX = "${config.h.xdg.dataHome}/npm";
        NPM_CONFIG_USERCONFIG = "${config.h.xdg.configHome}/npm/config";
        YARN_RC_FILENAME = "${config.h.xdg.configHome}/yarn/config";
        CARGO_HOME = "${config.h.xdg.dataHome}/cargo";
        LESSHISTFILE = "/dev/null";
        JAVA_HOME = "${jdk21}";
        JAVA_RUN = "${jdk21}/bin/java";
        JDK21 = jdk21;
        JDK17 = jdk17;
      };

      packages = with pkgs; [
        # editor
        zola
        woff2
        ripgrep
        fd
        jq

        nodePackages_latest.npm
        nodejs
        yarn
        php

        # school (i.e. bs) languages
        maven
        dotnet-sdk_9

        # util
        smartmontools
        pinentry-tty
        imagemagick
        exiftool
      ];

      sessionPath = [ "$NPM_CONFIG_PREFIX/bin" "$CARGO_HOME/bin" ];
    };
  };
}
