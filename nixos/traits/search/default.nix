{ ... }:
{
  flake.nixosTraits.hosts.search =
    { config, mounts, ... }:
    {
      sops.envs.search = {
        sopsFile = ./secrets/.env;
      };
      virtualisation.docker-stack.search = {
        file = ./docker-compose.yaml;
        env = {
          DATA_DIR = "${mounts.config}/degoog";
        };
        envPath = config.sops.envs.search.path;
      };

      networking.firewall.allowedTCPPorts = [ 8080 ];
    };
}
