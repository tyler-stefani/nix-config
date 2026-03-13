{ ... }:
{
  flake.nixosTraits.hosts.notes =
    { config, mounts, ... }:
    {
      services.restic.backups.notes =
        let
          cfg = config.services.restic;
        in
        {
          initialize = true;
          paths = [
            "${mounts.data}/notes"
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
            "notes"
          ];
        };
    };
}
