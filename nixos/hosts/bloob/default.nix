{ inputs, config, ... }:
{
  flake.nixosConfigurations.bloob = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      traits = config.flake.nixosTraits;
    };
    modules = [
      inputs.nixos-wsl.nixosModules.default

      ./configuration.nix
    ];
  };
}
