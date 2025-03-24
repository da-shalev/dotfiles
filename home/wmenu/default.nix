{ lib, ... }: {
  options.h.wmenu = {
    enable = lib.mkEnableOption "Enables wmenu." // { default = true; };
    config = lib.mkOption {
      type = lib.types.str;
      default = ''-f "monospace 21" -s "#ffffff" -S "#b16286" -N "#000000"'';
    };
  };
}
