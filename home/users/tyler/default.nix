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

          (
            { pkgs, traits, ... }:
            {
              imports =
                with traits;
                [
                  editor
                  git
                  prompt
                  shell
                  styling
                ]
                ++ builtins.attrValues config.flake.homeModules;

              home = {
                username = "tyler";
                homeDirectory = if pkgs.stdenv.isDarwin then "/Users/tyler" else "/home/tyler";
              };

              home.stateVersion = "24.11";
            }
          )
        ];
      };
    }) config.systems
  );
}
