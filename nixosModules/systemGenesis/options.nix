{ lib, ... }: {
  options = {
    systemGenesis = {
      hostName = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        description = "This is your host name. Must be defined explicitly.";
      };

      architecture = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        description = "Your systems architecture. Must be defined explicitly.";
      };

      configPath = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        default = "/etc/nixos";
        description = "Systemwide configuration location.";
      };

      rootIsTmpfs = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the root filesystem (/) is tmpfs. If true the impermanence module activates.";
      };
    };
  };
}
