{ ... }:
{
  lab.traits.programs.terminal.home =
    { pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        settings = {
          font-family = "ComicCode Nerd Font";
        };
      };

      home.packages = [ pkgs.ghostty.terminfo ];
    };
}
