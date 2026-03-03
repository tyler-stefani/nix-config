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
        };
        envPath = config.sops.envs.feed.path;
      };
      services.restic.stack-backups.feed = {
        paths = [ dataDir ];
        timerConfig = {
          OnCalendar = "Mon *-*-* 01:00";
          Persistent = true;
        };
      };
    };
}
