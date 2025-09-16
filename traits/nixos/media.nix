{ flakePath, ... }:
let
  configDir = "/home/tyler/apps/jellyfin/config";
in
{
  config.virtualisation.docker-compose.media = {
    dir = flakePath + /stacks/media;
    env = {
      CONFIG_DIR = configDir;
      MOVIE_DIR = "/home/tyler/shared/media/movies";
      SHOW_DIR = "/home/tyler/shared/media/shows";
    };
    backup = {
      enable = true;
      paths = [
        configDir
      ];
      timerConfig = {
        OnCalendar = "Mon *-*-* 01:00";
        Persistent = true;
      };
    };
  };
}
