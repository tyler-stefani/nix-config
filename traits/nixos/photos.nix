{ config, self, ... }:
{
  config.virtualisation.docker-compose.photos = {
    dir = self + /stacks/photos;
    env = {
      UPLOAD_LOCATION = "/home/tyler/apps/immich/upload";
      LIBRARY_LOCATION = "${config.hostConfig.directories.personalData}/photos/library";
      BACKUP_LOCATION = "${config.hostConfig.directories.appData}/immich";
      DB_DATA_LOCATION = "/home/tyler/apps/immich/postgres";
      TZ = "America/Chicago";
      IMMICH_VERSION = "v1.134.0";
      DB_DATABASE_NAME = "immich";
      DB_USERNAME = "postgres";
      DB_PASSWORD = builtins.readFile (self + /secrets/photos/db-password);
    };
  };
}
