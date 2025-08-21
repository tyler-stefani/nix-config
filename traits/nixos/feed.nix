{ self, ... }:
{
  config.virtualisation.docker-compose.feed =
    let
      dataDir = "/home/tyler/apps/miniflux/data";
    in
    {
      dir = self + /stacks/feed;
      env = {
        MINIFLUX_VERSION = "2.2.11";
        DATA_DIR = dataDir;
        DB_PASSWORD = builtins.readFile (self + /secrets/feed/db-password);
        API_TOKEN = builtins.readFile (self + /secrets/feed/api-key);
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
