{ ... }:
{
  lab.traits.hosts.minecraft.nixos =
    { config, mounts, ... }:
    let
      minecraftDir = "${mounts.config}/minecraft/data";
      netbirdDir = "${mounts.config}/netbird/client/data";
    in
    {
      virtualisation.docker-compose.minecraft = {
        file = ./docker-compose.yaml;
        env = {
          MINECRAFT_DIR = minecraftDir;
          NETBIRD_DIR = netbirdDir;
        };
      };
      services.restic.serviceBackups.minecraft = {
        serviceName = config.virtualisation.docker-compose.minecraft.serviceName;
        paths = [
          minecraftDir
          netbirdDir
        ];
      };
    };
}
