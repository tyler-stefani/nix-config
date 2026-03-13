{ ... }:
{
  flake.nixosTraits.hosts.feed =
    { config, mounts, ... }:
    let
      dataDir = "${mounts.config}/miniflux/data";
    in
    {
      sops.envs.feed = {
        sopsFile = ./secrets/.env;
      };
      virtualisation.docker-compose.feed = {
        file = ./docker-compose.yaml;
        env = {
          MINIFLUX_VERSION = "2.2.11";
          DATA_DIR = dataDir;
          OAUTH2_PROVIDER = "oidc";
          ENV_FILE_PATH = config.sops.envs.feed.path;
        };
        envPath = config.sops.envs.feed.path;
      };
      services.restic.serviceBackups.feed = {
        serviceName = config.virtualisation.docker-compose.feed.serviceName;
        paths = [ dataDir ];
        timerConfig = {
          OnCalendar = "Mon *-*-* 03:00";
          Persistent = true;
        };
      };
    };
}
