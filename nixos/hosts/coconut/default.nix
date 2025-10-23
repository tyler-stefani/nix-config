{
  inputs,
  config,
  ...
}:
{
  flake.nixosConfigurations.coconut = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      traits = config.flake.nixosTraits;
    };
    modules = [
      inputs.sops-nix.nixosModules.sops
      ./configuration.nix
    ]
    ++ builtins.attrValues config.flake.nixosModules;
  };
}
