{ ... }:
{
  lab.traits.hosts.media.nixos =
    { config, mounts, ... }:
    let
      configDir = "${mounts.config}/jellyfin/config";
      multiScrobblerConfigDir = "${mounts.config}/multi-scrobbler/config";
    in
    {
      sops.envs.multi-scrobbler = {
        sopsFile = ./secrets/.env;
      };
      virtualisation.docker-compose.media = {
        file = ./docker-compose.yaml;
        env = {
          JELLYFIN_VERSION = "10.11.6";
          SCROBBLER_VERSION = "0.14.2";
          CONFIG_DIR = configDir;
          SCROBBLER_CONFIG_DIR = multiScrobblerConfigDir;
          MOVIE_DIR = "${mounts.media}/movies";
          SHOW_DIR = "${mounts.media}/shows";
          MUSIC_DIR = "${mounts.media}/music";
          JELLYFIN_USER = "tyler";
        };
        envPath = config.sops.envs.multi-scrobbler.path;
      };
      services.restic.serviceBackups.media = {
        serviceName = config.virtualisation.docker-compose.media.serviceName;
        paths = [
          configDir
          multiScrobblerConfigDir
        ];
        timerConfig = {
          OnCalendar = "Mon *-*-* 03:00";
          Persistent = true;
        };
      };
    };
}
