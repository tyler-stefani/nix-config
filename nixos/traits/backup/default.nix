{ ... }:
{
  flake.nixosTraits.backup =
    { config, mounts, ... }:
    let
      mkBackup =
        { name, path }:
        {
          initialize = true;
          paths = [ path ];
          timerConfig = {
            OnCalendar = "01:00";
            Persistent = true;
            RandomizedDelaySec = 1800;
          };
          repositoryFile = config.sops.secrets."backup/repository".path;
          environmentFile = config.sops.envs.backup.path;
          passwordFile = config.sops.secrets."backup/password".path;
          extraBackupArgs = [
            "--tag"
            name
          ];
        };
    in
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
        backups = {
          notes = mkBackup {
            name = "notes";
            path = "${mounts.data}/notes";
          };
          records = mkBackup {
            name = "records";
            path = "${mounts.data}/records";
          };
        };
      };
    };
}
