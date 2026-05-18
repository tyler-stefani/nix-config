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
                description = "Traits this host has";
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
      homes = mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              system = mkOption {
                type = types.str;
                default = "x86_64-linux";
                description = "The system architecture for the host which this home will live";
              };
              traits = mkOption {
                type = lib.types.functionTo (lib.types.listOf lib.types.raw);
                default = _: [ ];
                description = "Traits this home has";
              };
              config = mkOption {
                type = types.deferredModule;
                default = { };
                description = "The base configuration module for this home";
              };
            };
          }
        );
      };
    };
    traits =
      let
        traitType = types.attrsOf (
          types.submodule {
            options = {
              nixos = mkOption {
                type = types.deferredModule;
                default = null;
              };
              darwin = mkOption {
                type = types.deferredModule;
                default = null;
              };
              home = mkOption {
                type = types.deferredModule;
                default = null;
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
        homeConfigurations = mapAttrs (
          name: value:
          inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import inputs.nixpkgs { inherit (value) system; };
            modules = [
              inputs.nixvim.homeModules.nixvim
              inputs.stylix.homeModules.stylix
              inputs.nix-index-database.homeModules.default

              value.config
            ]
            ++ builtins.attrValues config.flake.homeModules
            ++ collectModules "home" value.traits;
          }
        ) cfg.entities.homes;
      };
    };
}
