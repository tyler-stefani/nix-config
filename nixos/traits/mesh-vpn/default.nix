{ ... }:
{
  flake.nixosTraits.hosts.mesh-vpn =
    { config, mounts, ... }:
    {
      sops.envs = {
        mesh-vpn-dash = {
          sopsFile = ./secrets/dashboard.env;
        };
        mesh-vpn-proxy = {
          sopsFile = ./secrets/proxy.env;
        };
      };
      virtualisation.docker-compose.mesh-vpn = {
        file = ./docker-compose.yml;
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
}
