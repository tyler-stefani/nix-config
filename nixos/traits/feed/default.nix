{ ... }:
{
  flake.nixosTraits.feed =
    { mounts, ... }:
    {
      config.virtualisation.docker-compose.feed =
        let
          dataDir = "${mounts.config}/miniflux/data";
        in
        {
          file = ./docker-compose.yaml;
          env = {
            MINIFLUX_VERSION = "2.2.11";
            DATA_DIR = dataDir;
            DB_PASSWORD = builtins.readFile ./secrets/db-password;
            API_TOKEN = builtins.readFile ./secrets/api-key;
            BASE_URL = builtins.readFile ./secrets/base-url;
          };
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
