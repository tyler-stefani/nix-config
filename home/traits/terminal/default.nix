{ ... }:
{
  flake.homeTraits.terminal =
    { ... }:
    {
      programs.ghostty = {
        enable = true;
        settings = {
          font-family = "ComicCode Nerd Font";
        };
      };
    };
}
