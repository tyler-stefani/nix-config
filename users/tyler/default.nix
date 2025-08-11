{ self, pkgs, ... }:
{
  home.username = "tyler";
  home.homeDirectory = "/home/tyler";
  programs = {
    fish = {
      enable = true;
      shellAbbrs = {
        ls = "eza -g --icons";
        ll = "eza -l --icons";
        la = "eza -ga --icons";
        tree = "eza -T --icons";
        cd = "z";
        cat = "bat";
      };
      functions = {
        fish_greeting = {
          body = "";
        };
      };
      plugins = [
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair.src;
        }
        {
          name = "fzf";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
        {
          name = "zoxide";
          src = pkgs.fetchFromGitHub {
            owner = "kidonng";
            repo = "zoxide.fish";
            rev = "bfd5947bcc7cd01beb23c6a40ca9807c174bba0e";
            hash = "sha256-Hq9UXB99kmbWKUVFDeJL790P8ek+xZR5LDvS+Qih+N4=";
          };
        }
        {
          name = "starship";
          src = pkgs.fetchFromGitHub {
            owner = "tyler-stefani";
            repo = "starship";
            rev = "fff9bc53ef9997775d31d860246af88cd7721ec8";
            hash = "sha256-S/Vt/jfYTCrMXXfu6YUIv+d0RoT7GYG1isayhtHc7DA=";
          };
        }
      ];
    };
    starship = {
      enable = true;
      enableTransience = true;
      settingsPath = ./starship.toml;
    };
    git = {
      enable = true;
      userEmail = "tylerjstefani@gmail.com";
      userName = "tyler";
      signing.format = null;
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        push = {
          autoSetupRemote = "true";
        };
      };
    };
  };
  home.stateVersion = "24.11";
}
