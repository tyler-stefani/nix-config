{
  inputs,
  config,
  traits,
  ...
}:
{
  flake.nixosConfigurations.homeserver = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit traits;
    };
    modules = [
      ./configuration.nix
    ]
    ++ builtins.attrValues config.flake.nixosModules;
  };
}
