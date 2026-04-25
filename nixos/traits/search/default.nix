{ ... }:
{
  flake.nixosTraits.hosts.search =
    { config, mounts, ... }:
    {
      virtualisation.docker-stack.search = {
        file = ./docker-compose.yaml;
        env = {
          DATA_DIR = "${mounts.config}/degoog";
        };
        envPath = config.sops.envs.search.path;
      };
    };
}
