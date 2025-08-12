{ lib, config, ... }:
with lib;
let
  cfg = config.programs.starship;
in
{
  config = mkIf cfg.enable {
    programs.fish.interactiveShellInit = mkIf cfg.enableFishIntegration (mkDefault ''
      if test "$TERM" != "dumb"
        ${optionalString cfg.enableTransience "enable_transience"}
      end
    '');
  };
}
