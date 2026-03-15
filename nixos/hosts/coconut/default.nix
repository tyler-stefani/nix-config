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
      nixpkgs-unstable = import inputs.nixpkgs-unstable {
        system = "x86_64-linux";
      };
    };
    modules = [
      inputs.sops-nix.nixosModules.sops
      ./configuration.nix
    ]
    ++ builtins.attrValues config.flake.nixosModules;
  };
}
