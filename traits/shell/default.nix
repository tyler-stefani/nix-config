{ ... }:
{
  lab.traits.has.shell.home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        eza
        bat
        zoxide
      ];

      programs.fish = {
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
          nixdeploy =
            let
              hosts = ''
                "bubblegum=bubblegum" \
                "coconut=coconut" \
                "cookies-and-cream=23.95.220.100"
              '';
            in
            {
              body = builtins.readFile (pkgs.replaceVars ./nixdeploy.fish { inherit hosts; });
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
              rev = "01a3b811f1f8e9c7196b77ef779d670e2cd5f3ff";
              hash = "sha256-7axiFSyfv8DiAM2ONQ/CkEu0AVWHnndlVW+4QMyEt60=";
            };
          }
        ];
      };

      stylix.targets = {
        bat.enable = true;
        fish.enable = true;
      };
    };
}
