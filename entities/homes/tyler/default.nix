{ lib, pkgs, ... }:
let
  username = "tyler";

  headlessTraits =
    { has, ... }:
    with has;
    [
      editor
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
      deploy ? null,
    }:
    {
      inherit system deploy;
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
        with has;
        [
          browser
          coding-agent
          graphical-editor
          terminal
          git
        ];
      config =
        { pkgs, ... }:
        {
          programs = {
            discord.enable = true;
          };

          home.packages = with pkgs; [
            beeper
            # bitwarden-desktop
            deploy-rs
            ente-auth
            obsidian
          ];
        };
    };
    "${username}@bubblegum" = mkHome {
      system = "x86_64-linux";
      traits = { has, ... }: [ has.git ];
      deploy = {
        inherit username;
        hostname = "192.168.1.68";
      };
    };
    "${username}@coconut" = mkHome {
      system = "x86_64-linux";
      traits = { has, ... }: [ has.git ];
      deploy = {
        inherit username;
        hostname = "192.168.1.69";
      };
    };
    "${username}@cookies-and-cream" = mkHome {
      system = "x86_64-linux";
      traits = { has, ... }: [ has.git ];
      deploy = {
        inherit username;
        hostname = "23.95.220.100";
      };
    };
    "${username}@noodle" = mkHome {
      system = "x86_64-darwin";
      traits = { has, ... }: [ has.git ];
      config = {
        home.homeDirectory = mkForce "/Users/tyler";
      };
    };
    "${username}@peppermint" = mkHome {
      system = "aarch64-darwin";
      traits = { has, ... }: [ has.git-work ];
      config = {
        home.homeDirectory = mkForce "/Users/tylerstefani";
      };
    };
  };
}
