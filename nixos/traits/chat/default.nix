{ ... }:
{
  flake.nixosTraits.chat =
    { config, mounts, ... }:
    {
      sops.envs.chat = {
        sopsFile = ./secrets/.env;
      };
      virtualisation.docker-stack.chat =
        let
          dataDir = "${mounts.data}/chat";
          configDir = "${mounts.config}/matrix";
        in
        {
          file = ./docker-compose.yaml;
          env = {
            DATA_DIR = dataDir;
            CONFIG_DIR = configDir;
          };
          envPath = config.sops.envs.chat.path;
        };
    };
}
