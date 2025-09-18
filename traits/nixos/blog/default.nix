{ config, ... }:
let
  appDir = "${config.host.mounts.config}/blog";
in
{
  config.virtualisation.docker-compose.blog = {
    dir = ./.;
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
}
