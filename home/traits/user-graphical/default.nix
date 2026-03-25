{ ... }:
{
  flake.homeTraits.user-graphical =
    { pkgs, traits, ... }:
    {
      imports = with traits; [
        browser
        terminal
      ];

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
}
