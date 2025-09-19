{ mounts, ... }:
{
  config.virtualisation.docker-compose.feed =
    let
      dataDir = "${mounts.config}/miniflux/data";
    in
    {
      dir = ./.;
      env = {
        MINIFLUX_VERSION = "2.2.11";
        DATA_DIR = dataDir;
        DB_PASSWORD = builtins.readFile ./secrets/db-password;
        API_TOKEN = builtins.readFile ./secrets/api-key;
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
}
