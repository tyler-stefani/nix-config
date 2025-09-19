{ mounts, ... }:
let
  configDir = "${mounts.config}/jellyfin/config";
in
{
  config.virtualisation.docker-compose.media = {
    dir = ./.;
    env = {
      CONFIG_DIR = configDir;
      MOVIE_DIR = "${mounts.media}/movies";
      SHOW_DIR = "${mounts.media}/shows";
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
