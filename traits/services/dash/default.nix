{ ... }:
{

  lab.traits.services.dash.nixos = {
    hostname = "dash-app";
    module =
      {
        config,
        lib,
        pkgs,
        mounts,
        ...
      }:
      let
        configDir = "${mounts.config}/glance";
        composeService = config.virtualisation.docker-compose.dash.serviceName;
        themeFile = pkgs.writeText "glance-theme.yml" (
          lib.concatMapStrings (line: line + "\n") (
            lib.mapAttrsToList (
              name: value: "${name}: ${builtins.toJSON value}"
            ) config.services.glance.settings.theme
          )
        );
      in
      {
        sops.envs.dash = {
          sopsFile = ./secrets/.env;
        };
        virtualisation.docker-compose.dash = {
          file = ./docker-compose.yaml;
          env = {
            GLANCE_VERSION = "v0.8.4";
            CONFIG_DIR = configDir;
            THEME_FILE = "${themeFile}";
          };
          envPath = config.sops.envs.dash.path;
          restartTriggers = [ themeFile ];
        };
        stylix.targets = {
          glance.enable = true;
        };
        services.restic.serviceBackups.dash = {
          serviceName = composeService;
          paths = [
            configDir
          ];
        };
      };
  };
}
