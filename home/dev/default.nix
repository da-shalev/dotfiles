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
        SHELL = "${lib.getBin config.h.shell.package}/bin/${
            lib.getName config.h.shell.package
          }";
        GOPATH = "${config.h.dataHome}/go";
        NPM_CONFIG_PREFIX = "${config.h.dataHome}/npm";
        NPM_CONFIG_USERCONFIG = "${config.h.configHome}/npm/config";
        CARGO_HOME = "${config.h.dataHome}/cargo";
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
        php

        # school (i.e. bs) languages
        maven
        dotnet-sdk_8

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
