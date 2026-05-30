{ ... }:
{
  lab.traits.hosts.wiki.nixos =
    { config, mounts, ... }:
    {
      sops.envs.wiki = {
        sopsFile = ./secrets/.env;
      };
      virtualisation.docker-compose.wiki = {
        file = ./docker-compose.yaml;
        env = {
          CONFIG_DIR = "${mounts.config}/leafwiki";
        };
        envPath = config.sops.envs.wiki.path;
      };
    };
}
