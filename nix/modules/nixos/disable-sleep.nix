{ lib, ... }: {
  flake.modules.nixos.disable-sleep.systemd.targets =
    lib.genAttrs [ "sleep" "suspend" "hibernate" "hybrid-sleep" ]
    (_: { enable = lib.mkForce false; });
}
