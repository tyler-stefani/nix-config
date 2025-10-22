{ inputs, config, ... }:
{
  flake.homeConfigurations = builtins.listToAttrs (
    builtins.map (system: {
      name = "tyler@${system}";
      value = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs { inherit system; };
        extraSpecialArgs = {
          traits = config.flake.homeTraits;
        };
        modules = [
          inputs.nixvim.homeModules.nixvim
          inputs.stylix.homeModules.stylix

          ./configuration.nix
        ]
        ++ builtins.attrValues config.flake.homeModules;
      };
    }) config.systems
  );
}
