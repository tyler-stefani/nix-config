{ mounts, ... }:
{
  config.virtualisation.docker-compose.keep = {
    dir = ./.;
    env = {
      KARAKEEP_VERSION = "0.26.0";
      DATA_DIR = "${mounts.config}/karakeep/data";
      NEXTAUTH_SECRET = builtins.readFile ./secrets/nextauth-secret;
      MEILI_MASTER_KEY = builtins.readFile ./secrets/meili-master-key;
      NEXTAUTH_URL = builtins.readFile ./secrets/nextauth-url;
    };
  };
}
