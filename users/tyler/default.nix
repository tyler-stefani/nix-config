{ self, pkgs, ... }:
{
  imports = [
    (self + /traits/all/ide.nix)
  ];

  home = {
    username = "tyler";
    homeDirectory = "/home/tyler";
    packages = with pkgs; [
      eza
      bat
      zoxide
      starship
    ];
  };

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
      settings = pkgs.lib.importTOML ./starship.toml;
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

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    targets = {
      fish.enable = true;
      nixvim.enable = true;
      starship.enable = true;
    };
  };

  home.stateVersion = "24.11";
}
