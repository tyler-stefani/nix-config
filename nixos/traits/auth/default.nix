{ ... }:
{
  flake.nixosTraits.auth =
    { config, mounts, ... }:
    let
      dataDir = "${mounts.config}/authentik/data";
      mediaDir = "${mounts.config}/authentik/media";
      templatesDir = "${mounts.config}/authentik/templates";
      certsDir = "${mounts.config}/authentik/certs";
    in
    {
      sops.envs.auth = {
        sopsFile = ./secrets/.env;
      };

      virtualisation.docker-compose.auth = {
        file = ./docker-compose.yaml;
        envPath = config.sops.envs.auth.path;
        env = {
          AUTHENTIK_TAG = "2025.10.2";
          DATA_DIR = dataDir;
          MEDIA_DIR = mediaDir;
          TEMPLATES_DIR = templatesDir;
          CERTS_DIR = certsDir;
        };
      };
    };
}
