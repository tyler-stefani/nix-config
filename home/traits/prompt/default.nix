{ ... }:
{
  flake.homeTraits.prompt =
    { pkgs, ... }:
    {
      programs.starship = {
        enable = true;
        enableTransience = true;
        settings = pkgs.lib.importTOML ./starship.toml;
      };
    };
}
