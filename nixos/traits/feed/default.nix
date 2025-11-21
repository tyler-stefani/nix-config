{ ... }:
{
  flake.nixosTraits.feed =
    { config, mounts, ... }:
    {
      sops.envs.feed = {
        sopsFile = ./secrets/.env;
      };
      virtualisation.docker-compose.feed =
        let
          dataDir = "${mounts.config}/miniflux/data";
        in
        {
          file = ./docker-compose.yaml;
          env = {
            MINIFLUX_VERSION = "2.2.11";
            DATA_DIR = dataDir;
          };
          envPath = config.sops.envs.feed.path;
          backup = {
            enable = true;
            paths = [ dataDir ];
            timerConfig = {
              OnCalendar = "Mon *-*-* 01:00";
              Persistent = true;
            };
          };
        };
    };
}
