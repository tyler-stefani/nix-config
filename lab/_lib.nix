{
  lib,
}:
let
  inherit (lib)
    types
    mkOption
    mkEnableOption
    filter
    map
    ;

  # Submodule type for an entity's declarative deployment configuration.
  deployType = types.submodule {
    options = {
      enable = mkEnableOption "declarative deployment of this entity to a server";
      hostname = mkOption { type = types.str; };
      username = mkOption { type = types.str; };
    };
  };

  # Options common to hosts and homes.
  entityType = {
    system = mkOption {
      type = types.str;
      default = "x86_64-linux";
      description = "System architecture for this entity";
    };
    config = mkOption {
      type = types.deferredModule;
      default = { };
      description = "Base configuration module for this entity";
    };
    traits = mkOption {
      type = types.listOf types.raw;
      default = [ ];
      description = "Traits this entity has";
    };
    deploy = mkOption {
      default = { };
      description = "Configuration for declarative deployments, only to be used for hosts and homes on servers";
      type = deployType;
    };
  };

  # Options specific to hosts.
  hostExtraType = {
    mounts = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Absolute paths to state not directly managed by nix";
    };
    networking = mkOption {
      default = { };
      description = "IP addresses which are claimed by this host";
      type = types.submodule {
        options = {
          ips = mkOption {
            type = types.submodule {
              options = {
                self = mkOption {
                  type = types.str;
                  description = "LAN IP address for this host";
                };
                dns = mkOption {
                  type = types.str;
                  description = "Additional LAN IP address for the DNS server hosted by this host";
                };
                macvlan-shim = mkOption {
                  type = types.str;
                  description = "Additional unused LAN IP address for a shim that facilitates communication with docker macvlan containers";
                };
              };
            };
          };
          macs = mkOption {
            default = { };
            description = "MAC addresses which are given to oci containers to be used on MACVLANs";
            type = types.submodule {
              options = {
                dns = mkOption {
                  type = types.str;
                  description = "Private MAC address given to the DNS server container";
                };
                macvlan-shim = mkOption {
                  type = types.str;
                  description = "Private MAC address given to the MACVLAN shim that facilitates communication between host and container";
                };
              };
            };
          };
          interfaces = mkOption {
            default = { };
            type = types.submodule {
              options = {
                primary = mkOption {
                  type = types.str;
                  description = "The primary ethernet interface this host uses";
                };
              };
            };
          };
        };
      };
    };
  };

  hostType = entityType // hostExtraType;

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

  # Extract an entity's selected trait modules for a given system type.
  # Every trait lives under its system type (nixos/darwin/home); a service type
  # further unwraps to its deferred module.
  selectTraits =
    systemType: select:
    filter (trait: trait != null) (
      map (
        trait:
        if trait ? ${systemType} then
          let
            v = trait.${systemType};
          in
          if v ? module then v.module else v
        else
          null # trait not declared for this system type
      ) select
    );
in
{
  inherit
    entityType
    hostType
    traitType
    selectTraits
    ;
}
