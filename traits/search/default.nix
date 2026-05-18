{ ... }:
{
  lab.traits.hosts.search.nixos =
    { config, mounts, ... }:
    {
      virtualisation.docker-stack.search = {
        file = ./docker-compose.yaml;
        env = {
          DATA_DIR = "${mounts.config}/degoog";
        };
      };
    };
}
