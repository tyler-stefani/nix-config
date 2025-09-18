{
  config,
  ...
}:
let
  uploadDir = "${config.host.mounts.config}/immich/upload";
  libDir = "${config.host.mounts.data}/photos/library";
  extLibDir = "${config.host.mounts.data}/photos/library-kim";
  dbDir = "${config.host.mounts.config}/immich/postgres";
in
{
  config.virtualisation.docker-compose.photos = {
    dir = ./.;
    env = {
      UPLOAD_LOCATION = uploadDir;
      LIBRARY_LOCATION = libDir;
      EXTERNAL_LIBRARY_LOCATION = extLibDir;
      BACKUP_LOCATION = "/home/tyler/shared/safe/apps/immich";
      DB_DATA_LOCATION = dbDir;
      TZ = "America/Chicago";
      IMMICH_VERSION = "v1.138.1";
      DB_DATABASE_NAME = "immich";
      DB_USERNAME = "postgres";
      DB_PASSWORD = builtins.readFile ./secrets/db-password;
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
