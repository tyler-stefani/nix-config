{ config, ... }:
let
  minecraftDir = "${config.host.mounts.config}/minecraft/data";
  netbirdDir = "${config.host.mounts.config}/netbird/client/data";
in
{
  config.virtualisation.docker-compose.minecraft = {
    dir = ./.;
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
