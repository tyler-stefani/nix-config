{ ... }:
{
  flake.nixosTraits.hosts.records =
    { config, mounts, ... }:
    {
      services.restic.backups.records =
        let
          cfg = config.services.restic;
        in
        {
          initialize = true;
          paths = [
            "${mounts.data}/records"
          ];
          timerConfig = {
            OnCalendar = "03:00";
            Persistent = true;
            RandomizedDelaySec = 1800;
          };
          repositoryFile = cfg.defaultRepositoryFile;
          environmentFile = cfg.defaultEnvironmentFile;
          passwordFile = cfg.defaultPasswordFile;
          extraBackupArgs = [
            "--tag"
            "records"
          ];
        };
    };
}
