{ localFlake, ... }:
{
  config,
  lib,
  inputs,
  withSystem,
  self,
  flake-parts-lib,
  ...
}:

let
  allowedSystems = [
    "aarch64-linux"
    "x86_64-linux"
  ];
  modulesPath = "${inputs.nixpkgs.outPath}/nixos/modules";

  genHostId = hostName: builtins.substring 0 8 <| builtins.hashString "md5" hostName;

  pathIfExists = p: if p != null && builtins.pathExists p then p else null;
  tryPath =
    basePath: name:
    lib.optional (basePath != null) "${basePath}/${name}.nix" |> lib.head or null |> pathIfExists;

  paths = {
    perSystem = pathIfExists config.flake.compootuers.perSystem;
    perArch = pathIfExists config.flake.compootuers.perArch;
    allSystems = pathIfExists config.flake.compootuers.allSystems;
  };

  getConfigFiles =
    {
      pathType,
      system ? null,
      hostDir ? null,
      fileNameSelector ? [ ],
    }:
    let
      basePath =
        let
          options = {
            global = paths.allSystems;
            arch = if paths.perArch != null then "${paths.perArch}/${system}" else null;
            host = hostDir;
          };
        in
        options.${pathType} or null;
    in
    lib.optionals (basePath != null) (
      map (
        name:
        let
          file = tryPath basePath name;
        in
        lib.optional (file != null) file
      ) fileNameSelector
      |> lib.flatten
    );

  computedCompootuers = lib.optionals (paths.perSystem != null) (
    map (
      system:
      let
        dir = "${paths.perSystem}/${system}";
      in
      builtins.readDir dir
      |> builtins.attrNames
      |> map (hostName: {
        inherit system hostName;
        src = "${dir}/${hostName}";
      })
      |> lib.optionals (builtins.pathExists dir)
    ) allowedSystems
    |> lib.flatten
  );

  configForSub =
    {
      sub,
      iso ? false,
    }:
    let
      inherit (sub) system src hostName;

      fileNameSelector = [ "_both" ] ++ (if iso then [ "_iso" ] else [ "_default" ]);

      globalFiles = getConfigFiles {
        pathType = "global";
        inherit fileNameSelector;
      };

      archFiles = getConfigFiles {
        pathType = "arch";
        inherit system fileNameSelector;
      };

      hostFiles = getConfigFiles {
        pathType = "host";
        hostDir = src;
        inherit fileNameSelector;
      };
    in
    withSystem system (
      {
        config,
        inputs',
        self',
        ...
      }:
      let
        baseModules = [
          {
            networking = { inherit hostName; };
            nixpkgs.pkgs = withSystem system ({ pkgs, ... }: pkgs);
          }
        ]
        ++ globalFiles
        ++ archFiles
        ++ hostFiles;

        nonIsoModules = lib.optionals (!iso) [
          (
            { lib, config, ... }:
            {
              networking.hostId = lib.mkDefault <| genHostId config.networking.hostName;
            }
          )
        ];

        isoModules = lib.optionals iso [
          (
            { lib, ... }:
            {
              imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-base.nix" ];
              boot.initrd.systemd.enable = lib.mkForce false;
              isoImage.squashfsCompression = "lz4";
              system.installer.channel.enable = lib.mkForce false;
              networking.hostId = lib.mkForce <| genHostId hostName;
              systemd.targets = lib.genAttrs [ "sleep" "suspend" "hibernate" "hybrid-sleep" ] (_: {
                enable = lib.mkForce false;
              });
              users.users.nixos = {
                initialPassword = "iso";
                initialHashedPassword = lib.mkForce null;
                hashedPassword = lib.mkForce null;
                password = lib.mkForce null;
                hashedPasswordFile = lib.mkForce null;
              };
            }
          )
        ];

        finalModules = baseModules ++ nonIsoModules ++ isoModules;
      in
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            inputs'
            self'
            self
            system
            ;
        };
        modules = finalModules;
      }
    );
in
{
  options.flake = flake-parts-lib.mkSubmoduleOptions {
    compootuers = {
      perSystem = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "directory tree: <root>/<system>/<host>/_*.nix";
      };
      perArch = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "optional overrides per architecture: <root>/<system>/_both|_default|_iso.nix";
      };
      allSystems = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "optional global overrides applied to every host.";
      };
    };
  };

  config = {
    flake.nixosConfigurations =
      map (sub: [
        {
          name = sub.hostName;
          value = configForSub {
            inherit sub;
            iso = false;
          };
        }
        {
          name = "${sub.hostName}-iso";
          value = configForSub {
            inherit sub;
            iso = true;
          };
        }
      ]) computedCompootuers
      |> lib.flatten
      |> builtins.listToAttrs;

    systems = computedCompootuers |> map ({ system, ... }: system) |> lib.unique;
  };
}
