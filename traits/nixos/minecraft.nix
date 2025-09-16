{ flakePath, ... }:
let
  minecraftDir = "/home/tyler/apps/minecraft/data";
  netbirdDir = "/home/tyler/apps/netbird/client/data";
in
{
  config.virtualisation.docker-compose.minecraft = {
    dir = flakePath + /stacks/minecraft;
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
