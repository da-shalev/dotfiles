{ pkgs, lib, ... }: {
  hardware = {
    nvidia.open = lib.mkDefault false;
    graphics = {
      enable32Bit = true;
    };
  };

  environment.systemPackages = with pkgs; [ rar unrar ];
}
