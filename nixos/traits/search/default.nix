{ ... }:
{
  flake.nixosTraits.search =
    { config, mounts, ... }:
    {
      sops.envs.search = {
        sopsFile = ./secrets/.env;
      };
      virtualisation.docker-compose.search = {
        file = ./docker-compose.yaml;
        env = {
          CONFIG_DIR = "${mounts.config}/searxng/config";
          DATA_DIR = "${mounts.config}/searxng/data";
          VALKEY_DATA_DIR = "${mounts.config}/searxng/valkey-data";
        };
        envPath = config.sops.envs.search.path;
      };

      networking.firewall.allowedTCPPorts = [ 8080 ];
    };
}
