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
    traits = {
      is = mkOption {
        type = types.attrsOf types.deferredModule;
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
        type = types.attrsOf types.deferredModule;
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
        type = types.attrsOf types.deferredModule;
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
        type = types.attrsOf types.deferredModule;
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
    in
    {
      flake = {
        nixosConfigurations = mapAttrs' (
          name: value:
          nameValuePair (name) (
            inputs.nixpkgs.lib.nixosSystem {
              system = value.system;
              specialArgs = {
                traits = cfg.traits;
                nixpkgs-unstable = import inputs.nixpkgs-unstable {
                  system = value.system;
                };
              };
              modules = [
                inputs.sops-nix.nixosModules.sops
                value.config
              ]
              ++ builtins.attrValues config.flake.nixosModules;
            }
          )
        ) cfg.entities.hosts;
        homeConfigurations = mapAttrs' (name: value: nameValuePair (name) ({ })) cfg.entities.homes;
      };
    };
}
