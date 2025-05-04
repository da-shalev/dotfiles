{ config, lib, ... }: {
  options.h.fd = {
    enable = lib.mkEnableOption "Enable fd." // { default = true; };
  };

  config = lib.mkIf config.h.fd.enable {
    programs.fd = {
      enable = true;
      ignores = [
        ".local"
        ".m2"
        ".cache"
        ".git"
        ".github"
        ".vscode"
        ".DS_Store"
        ".git/"
      ];
    };
  };
}
