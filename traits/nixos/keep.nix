{ self, ... }:
{
  config.virtualisation.docker-compose.keep = {
    dir = self + /stacks/keep;
    env = {
      KARAKEEP_VERSION = "0.26.0";
      DATA_DIR = "/home/tyler/apps/karakeep/data";
      NEXTAUTH_SECRET = builtins.readFile (self + /secrets/keep/nextauth-secret);
      MEILI_MASTER_KEY = builtins.readFile (self + /secrets/keep/meili-master-key);
      NEXTAUTH_URL = builtins.readFile (self + /secrets/keep/nextauth-url);
    };
  };
}
