{ ... }:
{
  flake.nixosTraits.hosts.media =
    { config, mounts, ... }:
    let
      configDir = "${mounts.config}/jellyfin/config";
    in
    {
      virtualisation.docker-compose.media = {
        file = ./docker-compose.yaml;
        env = {
          CONFIG_DIR = configDir;
          MOVIE_DIR = "${mounts.media}/movies";
          SHOW_DIR = "${mounts.media}/shows";
          MUSIC_DIR = "${mounts.media}/music";
        };
      };
      services.restic.serviceBackups.media = {
        serviceName = config.virtualisation.docker-compose.media.serviceName;
        paths = [
          configDir
        ];
        timerConfig = {
          OnCalendar = "Mon *-*-* 03:00";
          Persistent = true;
        };
      };
    };
}
