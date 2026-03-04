{ ... }:
{
  flake.nixosTraits.hosts.proxy =
    { config, mounts, ... }:
    let
      dataDir = "${mounts.config}/nginx/data";
      letsencryptDir = "${mounts.config}/nginx/letsencrypt";
    in
    {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      virtualisation.docker-compose.proxy = {
        file = ./docker-compose.yaml;
        env = {
          NPM_VERSION = "2.12.6";
          DATA_DIR = dataDir;
          LETSENCRYPT_DIR = letsencryptDir;
        };
      };
      services.restic.serviceBackups.proxy = {
        serviceName = config.virtualisation.docker-compose.proxy.serviceName;
        paths = [
          dataDir
          letsencryptDir
        ];
        timerConfig = {
          OnCalendar = "Mon *-*-* 03:00";
          Persistent = true;
        };
      };
    };
}
