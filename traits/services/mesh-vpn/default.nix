{ ... }:
{

  lab.traits.services.mesh-vpn.nixos = {
    hostname = "netbird-server";
    module =
      { config, mounts, ... }:
      let
        configDir = "${mounts.config}/netbird";
        dataDir = "${configDir}/data";
        letsencryptDir = "${configDir}/letsencrypt";
        proxyCertsDir = "${configDir}/proxy-certs";
        crowdsecDataDir = "${configDir}/crowdsec-data";
      in
      {
        sops.envs = {
          mesh-vpn-dash = {
            sopsFile = ./secrets/dashboard.env;
          };
          mesh-vpn-proxy = {
            sopsFile = ./secrets/proxy.env;
          };
          mesh-vpn-domain = {
            sopsFile = ./secrets/domain.env;
          };
        };
        virtualisation.docker-compose.mesh-vpn = {
          file = ./docker-compose.yml;
          envPath = config.sops.envs.mesh-vpn-domain.path;
          env = {
            DASHBOARD_ENV_PATH = config.sops.envs.mesh-vpn-dash.path;
            PROXY_ENV_PATH = config.sops.envs.mesh-vpn-proxy.path;
            CONFIG_PATH = configDir;
            NETBIRD_DATA_DIR = dataDir;
            LETSENCRYPT_DIR = letsencryptDir;
            PROXY_CERTS_DIR = proxyCertsDir;
            CROWDSEC_DATA_DIR = crowdsecDataDir;
          };
        };
        services.restic.serviceBackups.mesh-vpn = {
          serviceName = config.virtualisation.docker-compose.mesh-vpn.serviceName;
          paths = [
            configDir
          ];
        };
        networking.firewall.allowedTCPPorts = [
          80
          443
        ];
      };
  };
}
