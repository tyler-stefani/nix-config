{ ... }:
{
  lab.traits.hosts.search.nixos =
    { config, mounts, ... }:
    {
      virtualisation.docker-compose.search = {
        file = ./docker-compose.yaml;
        env = {
          DATA_DIR = "${mounts.config}/degoog";
        };
      };
    };
}
