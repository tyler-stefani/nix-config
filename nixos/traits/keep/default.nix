{ ... }:
{
  flake.nixosTraits.keep =
    { config, mounts, ... }:
    {
      sops.envs.keep = {
        sopsFile = ./secrets/.env;
      };
      virtualisation.docker-compose.keep = {
        file = ./docker-compose.yaml;
        env = {
          KARAKEEP_VERSION = "0.26.0";
          DATA_DIR = "${mounts.config}/karakeep/data";
        };
        envPath = config.sops.envs.keep.path;
      };
    };
}
