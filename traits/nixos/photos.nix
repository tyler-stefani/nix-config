{ config, self, ... }:
let
  uploadDir = "/home/tyler/apps/immich/upload";
  libDir = "${config.hostConfig.directories.personalData}/photos/library";
  extLibDir = "/home/tyler/shared/safe/data/photos/library-kim";
  dbDir = "/home/tyler/apps/immich/postgres";
in
{
  config.virtualisation.docker-compose.photos = {
    dir = self + /stacks/photos;
    env = {
      UPLOAD_LOCATION = uploadDir;
      LIBRARY_LOCATION = libDir;
      EXTERNAL_LIBRARY_LOCATION = extLibDir;
      BACKUP_LOCATION = "${config.hostConfig.directories.appData}/immich";
      DB_DATA_LOCATION = dbDir;
      TZ = "America/Chicago";
      IMMICH_VERSION = "v1.134.0";
      DB_DATABASE_NAME = "immich";
      DB_USERNAME = "postgres";
      DB_PASSWORD = builtins.readFile (self + /secrets/photos/db-password);
    };
    backup = {
      enable = true;
      paths = [
        uploadDir
        libDir
        extLibDir
        dbDir
      ];
    };
  };
}
