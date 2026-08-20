{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
  helpers = import ./_lib.nix { inherit lib; };
  inherit (helpers) traitType;

  # A trait for a service: a deferred module plus a hostname it is reachable at
  # for networking purposes. A bare deferred module is also accepted.
  serviceType = types.oneOf [
    (types.addCheck (types.submodule {
      options = {
        module = mkOption {
          type = types.deferredModule;
          default = null;
        };
        hostname = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Hostname/IP the service is reachable at for networking purposes";
        };
      };
    }) (value: lib.isAttrs value && (value ? module || value ? hostname)))
    types.deferredModule
  ];
in
{
  options.lab.traits = {
    attributes = mkOption {
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
    programs = mkOption {
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
    services = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            nixos = mkOption {
              type = serviceType;
              default = null;
            };
            darwin = mkOption {
              type = serviceType;
              default = null;
            };
            home = mkOption {
              type = serviceType;
              default = null;
            };
          };
        }
      );
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
  };
}
