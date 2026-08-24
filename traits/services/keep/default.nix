{ ... }:
{
  lab.traits.services.keep.nixos = {
    hostname = "keep";
    module =
      { config, mounts, ... }:
      let
        dataDir = "${mounts.config}/karakeep/data";
      in
      {
        sops.envs.keep = {
          sopsFile = ./secrets/.env;
        };
        virtualisation.docker-compose.keep = {
          file = ./docker-compose.yaml;
          env = {
            KARAKEEP_VERSION = "0.26.0";
            DATA_DIR = dataDir;
          };
          envPath = config.sops.envs.keep.path;
        };
        services.restic.serviceBackups.keep = {
          serviceName = config.virtualisation.docker-compose.keep.serviceName;
          paths = [ dataDir ];
          timerConfig = {
            OnCalendar = "Mon *-*-* 03:00";
            Persistent = true;
          };
        };
      };
  };
}
