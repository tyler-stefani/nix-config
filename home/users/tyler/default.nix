{ config, inputs, ... }:
{
  flake.homeConfigurations."tyler" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    extraSpecialArgs = {
      traits = config.flake.homeTraits;
    };
    modules = [
      inputs.nixvim.homeModules.nixvim
      inputs.stylix.homeModules.stylix

      (
        { pkgs, traits, ... }:
        {
          imports = with traits; [
            config.flake.homeModules.fish
            config.flake.homeModules.starship

            editor
            git
            prompt
            shell
            styling
          ];

          home = {
            username = "tyler";
            homeDirectory = "/home/tyler";
          };

          home.stateVersion = "24.11";
        }
      )
    ];
  };
}
