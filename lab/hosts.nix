{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    mapAttrs
    filterAttrs
    ;
  helpers = import ./_lib.nix { inherit lib; };
  inherit (helpers) hostType selectTraits;

  hosts = config.lab.entities.hosts;

  deployable = filterAttrs (name: value: value.deploy.enable);

  hostNode = name: value: {
    hostname = value.deploy.hostname;
    profiles.host = {
      user = "root";
      sshUser = value.deploy.username;
      path =
        inputs.deploy-rs.lib."${value.system}".activate.nixos
          config.flake.nixosConfigurations."${name}";
      interactiveSudo = true;
    };
  };
in
{
  options.lab.entities.hosts = mkOption {
    type = types.attrsOf (types.submodule { options = hostType; });
  };

  config.flake = {
    nixosConfigurations = mapAttrs (
      name: value:
      inputs.nixpkgs.lib.nixosSystem {
        system = value.system;
        specialArgs = {
          inherit (value) mounts networking;
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
        ++ selectTraits "nixos" value.traits;
      }
    ) hosts;

    deploy.nodes = mapAttrs hostNode (deployable hosts);
  };
}
