{ ... }:
{
  flake.nixosTraits.blog =
    { mounts, ... }:
    let
      appDir = "${mounts.config}/blog";
    in
    {
      config.virtualisation.docker-compose.blog = {
        file = ./docker-compose.yaml;
        env = {
          CONFIG_FILE = "${appDir}/config.ini";
          KEYS_DIR = "${appDir}/keys";
          DB_FILE = "${appDir}/writefreely.db";
        };
        backup = {
          enable = true;
          paths = [
            appDir
          ];
        };
      };
    };
}
