{ ... }:
{
  flake.homeModules.fish =
    { lib, config, ... }:
    let
      cfg = config.programs.fish;
    in
    {
      config = lib.mkIf cfg.enable {
        programs.man.generateCaches = lib.mkForce false;
      };
    };
}
