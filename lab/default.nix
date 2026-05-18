{
  lib,
  config,
  inputs,
  ...
}:
with lib;
{
  options.lab = {
    entities = {
      hosts = mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              system = mkOption {
                type = types.str;
                default = "x86_64-linux";
                description = "The system architecture for this host";
              };
              traits = mkOption {
                type = lib.types.functionTo (lib.types.listOf lib.types.raw);
                default = _: [ ];
                description = "Traits this entity has";
              };
              mounts = mkOption {
                type = types.attrsOf types.str;
                default = { };
                description = "Absolute paths to state not directly managed by nix";
              };
              ips = mkOption {
                type = types.attrsOf types.str;
                default = { };
                description = "IP addresses of this host and other services it makes available";
              };
              config = mkOption {
                type = types.deferredModule;
                default = { };
                description = "The base configuration module for this host";
              };
            };
          }
        );
      };
      homes = mkOption { };
    };
    traits =
      let
        traitType = types.attrsOf (
          types.submodule {
            options = {
              nixos = mkOption {
                type = types.deferredModule;
                default = { };
              };
              darwin = mkOption {
                type = types.deferredModule;
                default = { };
              };
              home = mkOption {
                type = types.deferredModule;
                default = { };
              };
            };
          }
        );
      in
      {
        is = mkOption {
          type = traitType;
          default = { };
          description = "Aspects of an entire entity which typically relate to a larger system";
          example = {
            ssh-server =
              { ... }:
              {
                services.openssh.enable = true;
              };
          };
        };
        has = mkOption {
          type = traitType;
          default = { };
          description = "Programs that an entity has access to";
          example = {
            games =
              { ... }:
              {
                programs.steam.enable = true;
              };
          };
        };
        hosts = mkOption {
          type = traitType;
          default = { };
          description = "Services that an entity hosts";
          example = {
            monitoring =
              { ... }:
              {
                services.grafana.enable = true;
              };
          };
        };
        manages = mkOption {
          type = traitType;
          default = { };
          description = "Services that an entity manages the hosting of, but does not necessarily host directly";
          example = {
            monitoring =
              { ... }:
              {
                services.grafana.enable = true;
              };
          };
        };
      };
  };
  config =
    let
      cfg = config.lab;
      collectModules =
        systemType: traits:
        pipe (traits cfg.traits) [
          (filter (trait: trait ? ${systemType}))
          (map (trait: trait.${systemType}))
        ];
    in
    {
      flake = {
        nixosConfigurations = mapAttrs (
          name: value:
          inputs.nixpkgs.lib.nixosSystem {
            system = value.system;
            specialArgs = {
              inherit (value) mounts ips;
              nixpkgs-unstable = import inputs.nixpkgs-unstable {
                system = value.system;
              };
            };
            modules = [
              inputs.sops-nix.nixosModules.sops
              inputs.disko.nixosModules.disko
              value.config
            ]
            ++ builtins.attrValues config.flake.nixosModules
            ++ collectModules "nixos" value.traits;
          }
        ) cfg.entities.hosts;
        homeConfigurations = mapAttrs' (name: value: nameValuePair (name) ({ })) cfg.entities.homes;
      };
    };
}
