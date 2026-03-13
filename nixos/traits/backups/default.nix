{ ... }:
{
  flake.nixosTraits.has.backups =
    { config, mounts, ... }:
    {
      sops = {
        envs.backup = {
          sopsFile = ./secrets/.env;
        };
        secrets = {
          "backup/password" = {
            sopsFile = ./secrets/secrets.yaml;
            key = "password";
          };
          "backup/repository" = {
            sopsFile = ./secrets/secrets.yaml;
            key = "repository";
          };
        };
      };
      services.restic = {
        enable = true;
        defaultRepositoryFile = config.sops.secrets."backup/repository".path;
        defaultEnvironmentFile = config.sops.envs.backup.path;
        defaultPasswordFile = config.sops.secrets."backup/password".path;
      };
    };
}
