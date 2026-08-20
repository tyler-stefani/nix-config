{ ... }:
{

  lab.traits.services.mesh-vpn.nixos = {
    hostname = "netbird-server";
    module =
      { config, mounts, ... }:
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
            CONFIG_PATH = "${mounts.config}/netbird";
          };
        };
        networking.firewall.allowedTCPPorts = [
          80
          443
        ];
      };
  };
}
