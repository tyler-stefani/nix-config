{ self, ... }:
{
  config.virtualisation.docker-compose.feed = {
    dir = self + /stacks/feed;
    env = {
      DATA_LOCATION = "home/tyler/apps/miniflux/data";
      DB_PASSWORD = builtins.readFile (self + /secrets/feed/db-password);
      API_TOKEN = builtins.readFile (self + /secrets/feed/api-key);
    };
  };
}
