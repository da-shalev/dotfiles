{ lib, ... }: {
  flake.modules.nixos.no-sleep.systemd.targets =
    lib.genAttrs [ "sleep" "suspend" "hibernate" "hybrid-sleep" ]
    (_: { enable = lib.mkForce false; });
}
