{ ... }:
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  virtualisation.docker-compose.proxy =
    let
      dataDir = "/home/tyler/apps/nginx/data";
      letsencryptDir = "/home/tyler/apps/nginx/letsencrypt";
    in
    {
      dir = ./.;
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
