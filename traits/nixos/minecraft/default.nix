{ mounts, ... }:
let
  minecraftDir = "${mounts.config}/minecraft/data";
  netbirdDir = "${mounts.config}/netbird/client/data";
in
{
  config.virtualisation.docker-compose.minecraft = {
    file = ./docker-compose.yaml;
    env = {
      MINECRAFT_DIR = minecraftDir;
      NETBIRD_DIR = netbirdDir;
    };
    backup = {
      enable = true;
      paths = [
        minecraftDir
        netbirdDir
      ];
    };
  };
}
