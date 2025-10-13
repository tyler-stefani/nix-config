{
  inputs,
  config,
  ...
}:
{
  flake.nixosConfigurations.homeserver = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      traits = config.flake.nixosTraits;
    };
    modules = [
      ./configuration.nix
    ]
    ++ builtins.attrValues config.flake.nixosModules;
  };
}
