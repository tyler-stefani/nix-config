{ lib, pkgs, ... }:
let
  username = "tyler";

  headlessTraits =
    { has, ... }:
    with has;
    [
      editor
      git
      prompt
      shell
      styling
    ];

  baseConfig =
    { pkgs, ... }:
    {
      home = {
        inherit username;
        homeDirectory = "/home/tyler";
      };
      nixpkgs.config.allowUnfree = true;
      programs.nix-index-database.comma.enable = true;
      home.stateVersion = "24.11";
    };

  mkHome =
    {
      system,
      traits ? (_: [ ]),
      config ? { },
    }:
    {
      inherit system;
      traits = { has, ... }@inputs: (headlessTraits inputs) ++ (traits inputs);
      config = {
        imports = [
          baseConfig
          config
        ];
      };
    };

in
with lib;
{
  lab.entities.homes = {
    "${username}@bloob" = mkHome {
      system = "x86_64-linux";
      traits =
        { has, ... }:
        [
          has.browser
          has.terminal
        ];
      config =
        { pkgs, ... }:
        {
          programs = {
            discord.enable = true;
            vscode = {
              enable = true;
              package = pkgs.vscodium;
            };
          };

          stylix.targets = {
            vscode.enable = true;
          };

          home.packages = with pkgs; [
            beeper
            bitwarden-desktop
            ente-auth
            obsidian
          ];
        };
    };
    "${username}@bubblegum" = mkHome { system = "x86_64-linux"; };
    "${username}@coconut" = mkHome { system = "x86_64-linux"; };
    "${username}@cookies-and-cream" = mkHome { system = "x86_64-linux"; };
    "${username}@noodle" = mkHome {
      system = "x86_64-darwin";
      config = {
        home.homeDirectory = mkForce "/Users/tyler";
      };
    };
  };
}
