{
  inputs,
  config,
  ...
}:
{
  flake.nixosConfigurations.cookies-and-cream = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      traits = config.flake.nixosTraits;
    };
    modules = [
      inputs.sops-nix.nixosModules.sops
      inputs.disko.nixosModules.disko
      ./configuration.nix
    ]
    ++ builtins.attrValues config.flake.nixosModules;
  };
}
