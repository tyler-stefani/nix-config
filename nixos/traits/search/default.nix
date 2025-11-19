{ ... }:
{
  flake.nixosTraits.search =
    { mounts, ... }:
    {
      sops.secrets."search/.env" = {
        format = "dotenv";
        sopsFile = ./secrets/.env;
        key = "";
      };
      virtualisation.docker-compose.search = {
        file = ./docker-compose.yaml;
        env = {
          CONFIG_DIR = "${mounts.config}/searxng/config";
          DATA_DIR = "${mounts.config}/searxng/data";
          VALKEY_DATA_DIR = "${mounts.config}/searxng/valkey-data";
        };
        envPath = "/run/secrets/search/.env";
      };

      networking.firewall.allowedTCPPorts = [ 8080 ];
    };
}
