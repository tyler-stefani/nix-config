{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.flake.deploy = mkOption {
    type = types.submodule {
      options.nodes = mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              hostname = mkOption { type = types.str; };
              profiles = mkOption {
                type = types.attrsOf types.raw;
                default = { };
                description = ''
                  Profiles which can be deployed to this node. These can be used
                  to activate NixOS, nix-darwin, and home-manager configurations, as
                  well as build any custom derivations and run any custom commands.
                '';
              };
            };
          }
        );
        default = { };
        description = "Nodes/servers which can be deployed to.";
      };
    };
    default = { };
    description = ''
      Deployment configuration for deploy-rs. Used by the `deploy` binary.
    '';
  };
}
