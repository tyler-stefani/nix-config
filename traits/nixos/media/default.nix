{ config, ... }:
let
  configDir = "${config.host.mounts.config}/jellyfin/config";
in
{
  config.virtualisation.docker-compose.media = {
    dir = ./.;
    env = {
      CONFIG_DIR = configDir;
      MOVIE_DIR = "${config.host.mounts.media}/movies";
      SHOW_DIR = "${config.host.mounts.media}/shows";
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
