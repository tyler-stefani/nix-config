{ inputs, config, ... }:
let
  mkHomeConfig =
    system:
    inputs.home-manager.lib.homeManagerConfiguration {
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
in
{
  flake.homeConfigurations = {
    "tyler@bloob" = mkHomeConfig "x86_64-linux";
    "tyler@coconut" = mkHomeConfig "x86_64-linux";
    "tyler@noodle" = mkHomeConfig "x86_64-darwin";
  };
}
