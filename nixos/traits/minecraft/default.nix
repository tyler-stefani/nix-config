{ ... }:
{
  flake.nixosTraits.hosts.minecraft =
    { mounts, ... }:
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
      services.restic.stack-backup.minecraft = {
        paths = [
          minecraftDir
          netbirdDir
        ];
      };
    };
}
