{ ... }:
{
  flake.nixosTraits.has.games =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
      };
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
      hardware.nvidia = {
        modesetting.enable = true;
        open = false;
        nvidiaSettings = true;
        powerManagement = {
          enable = false;
          finegrained = false;
        };
      };
    };
}
