{ ... }:
{
  flake.nixosModules.fish =
    { config, lib, ... }:
    let
      cfg = config.programs.fish;
    in
    {
      config = lib.mkIf cfg.enable {
        documentation.man.generateCaches = lib.mkForce false;
      };
    };
}
