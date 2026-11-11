{ ... }:
{

  lab.traits.services.contacts.nixos = {
    hostname = "contacts";
    module =
      { config, mounts, ... }:
      let
        dataDir = "${mounts.config}/radicale";
      in
      {
        sops.envs.contacts = {
          sopsFile = ./secrets/.env;
        };
        virtualisation.docker-compose.contacts = {
          file = ./docker-compose.yaml;
          env = {
            RADICALE_VERSION = "3.9.0.0";
            DATA_DIR = dataDir;
            ENV_FILE_PATH = config.sops.envs.contacts.path;
          };
          envPath = config.sops.envs.contacts.path;
        };
        services.restic.serviceBackups.contacts = {
          serviceName = config.virtualisation.docker-compose.contacts.serviceName;
          paths = [ dataDir ];
          timerConfig = {
            OnCalendar = "Mon *-*-* 03:00";
            Persistent = true;
          };
        };
      };
  };
}
