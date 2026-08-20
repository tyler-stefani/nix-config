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
    mkIf
    mapAttrs
    filterAttrs
    mapAttrs'
    nameValuePair
    last
    splitString
    ;
  helpers = import ./_lib.nix { inherit lib; };
  inherit (helpers) entityType selectTraits;

  homes = config.lab.entities.homes;

  deployable = filterAttrs (name: value: value.deploy.enable);

  homeNode = name: value: {
    hostname = value.deploy.hostname;
    profiles.home = {
      user = value.deploy.username;
      sshUser = value.deploy.username;
      path =
        inputs.deploy-rs.lib."${value.system}".activate.home-manager
          config.flake.homeConfigurations."${name}";
    };
  };
in
{
  options.lab.entities.homes = mkOption {
    type = types.attrsOf (types.submodule { options = entityType; });
  };

  config.flake = {
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
        ++ selectTraits "home" value.traits;
      }
    ) homes;

    deploy.nodes = mapAttrs' (
      name: value: nameValuePair (last (splitString "@" name)) (homeNode name value)
    ) (deployable homes);
  };
}
