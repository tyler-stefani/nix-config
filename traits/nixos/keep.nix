{ flakePath, ... }:
{
  config.virtualisation.docker-compose.keep = {
    dir = flakePath + /stacks/keep;
    env = {
      KARAKEEP_VERSION = "0.26.0";
      DATA_DIR = "/home/tyler/apps/karakeep/data";
      NEXTAUTH_SECRET = builtins.readFile (flakePath + /secrets/keep/nextauth-secret);
      MEILI_MASTER_KEY = builtins.readFile (flakePath + /secrets/keep/meili-master-key);
      NEXTAUTH_URL = builtins.readFile (flakePath + /secrets/keep/nextauth-url);
    };
  };
}
