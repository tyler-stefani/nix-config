{ ... }:
{
  flake.nixosTraits.hosts.dash =
    { config, mounts, ... }:
    let
      configDir = "${mounts.config}/glance";
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
        };
        envPath = config.sops.envs.dash.path;
      };
      services.restic.serviceBackups.dash = {
        serviceName = config.virtualisation.docker-compose.dash.serviceName;
        paths = [
          configDir
        ];
      };
    };
}
