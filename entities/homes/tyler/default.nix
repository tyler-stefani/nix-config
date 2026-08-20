{
  lib,
  pkgs,
  config,
  ...
}:
let
  username = "tyler";

  # Trait sets (attributes/programs/services) for building host/home trait lists.
  traits = config.lab.traits;

  headlessTraits = with traits; [
    programs.editor
    programs.prompt
    programs.shell
    programs.styling
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
      traits ? [ ],
      config ? { },
      deploy ? { },
    }:
    {
      inherit system deploy;
      traits = headlessTraits ++ traits;
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
      traits = with traits; [
        programs.browser
        programs.coding-agent
        programs.graphical-editor
        programs.terminal
        programs.git
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
      traits = with traits; [ programs.git ];
      deploy = {
        enable = true;
        inherit username;
        hostname = "192.168.1.68";
      };
    };
    "${username}@coconut" = mkHome {
      system = "x86_64-linux";
      traits = with traits; [ programs.git ];
      deploy = {
        enable = true;
        inherit username;
        hostname = "192.168.1.69";
      };
    };
    "${username}@cookies-and-cream" = mkHome {
      system = "x86_64-linux";
      traits = with traits; [ programs.git ];
      deploy = {
        enable = true;
        inherit username;
        hostname = "23.95.220.100";
      };
    };
    "${username}@noodle" = mkHome {
      system = "x86_64-darwin";
      traits = with traits; [ programs.git ];
      config = {
        home.homeDirectory = mkForce "/Users/tyler";
      };
    };
    "${username}@peppermint" = mkHome {
      system = "aarch64-darwin";
      traits = with traits; [ programs.git-work ];
      config = {
        home.homeDirectory = mkForce "/Users/tylerstefani";
      };
    };
  };
}
