{
  self,
  lib,
  inputs,
  config,
  ...
}:
let
  mkHomeConfig =
    system: headless:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs { inherit system; };
      extraSpecialArgs = {
        traits = config.flake.homeTraits;
      };
      modules = [
        inputs.nixvim.homeModules.nixvim
        inputs.stylix.homeModules.stylix
        inputs.nix-index-database.homeModules.default

        self.homeTraits.user-headless
      ]
      ++ builtins.attrValues config.flake.homeModules
      ++ lib.optional (!headless) self.homeTraits.user-graphical;
    };
in
{
  flake.homeConfigurations = {
    "tyler@bubblegum" = mkHomeConfig "x86_64-linux" true;
    "tyler@bloob" = mkHomeConfig "x86_64-linux" false;
    "tyler@coconut" = mkHomeConfig "x86_64-linux" true;
    "tyler@cookies-and-cream" = mkHomeConfig "x86_64-linux" true;
    "tyler@noodle" = mkHomeConfig "x86_64-darwin" true;
  };
}
