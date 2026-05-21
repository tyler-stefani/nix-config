{ ... }:
{
  lab.traits.has.prompt.home =
    { pkgs, ... }:
    {
      programs.starship = {
        enable = true;
        enableTransience = true;
        settings = pkgs.lib.importTOML ./starship.toml;
      };

      stylix.targets = {
        starship.enable = true;
      };
    };
}
