{ self, config, ... }: {
  imports = [ ./home/nixos.nix ];
  environment.etc.${config.rebuild.dir}.source = self;
}
