{
  flake.modules.nixos.tty-only = { lib, config, pkgs, ... }: {
    services.xserver.enable = lib.mkForce false;
    hardware.graphics.enable = lib.mkForce false;

    xdg = {
      mime.enable = lib.mkForce false;
      autostart.enable = lib.mkForce false;
      sounds.enable = lib.mkForce false;
      menus.enable = lib.mkForce false;
    };
  };
}
