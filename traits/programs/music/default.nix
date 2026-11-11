{ ... }:
{
  lab.traits.programs.music.home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.spotify ];
    };
}
