{ lib, config, ... }:
with lib;
let
  cfg = config.programs.starship;
in
{
  options.programs.starship = {
    settingsPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to existing toml configuration for starship";
    };
  };

  config = mkIf cfg.enable {
    home.file.".config/starship.toml" = mkIf (cfg.settingsPath != null) {
      source = cfg.settingsPath;
    };

    programs.fish.interactiveShellInit = mkIf cfg.enableFishIntegration (mkDefault ''
      if test "$TERM" != "dumb"
        ${optionalString cfg.enableTransience "enable_transience"}
      end
    '');
  };
}
