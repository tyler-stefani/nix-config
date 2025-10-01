{ mounts, ... }:
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  virtualisation.docker-compose.proxy =
    let
      dataDir = "${mounts.config}/nginx/data";
      letsencryptDir = "${mounts.config}/nginx/letsencrypt";
    in
    {
      file = ./docker-compose.yaml;
      env = {
        NPM_VERSION = "2.12.6";
        DATA_DIR = dataDir;
        LETSENCRYPT_DIR = letsencryptDir;
      };
      backup = {
        enable = true;
        paths = [
          dataDir
          letsencryptDir
        ];
        timerConfig = {
          OnCalendar = "Mon *-*-* 01:00";
          Persistent = true;
        };
      };
    };
}
