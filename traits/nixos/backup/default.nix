{ mounts, ... }:
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
      repositoryFile = builtins.toString ./secrets/repository;
      environmentFile = builtins.toString ./secrets/environment;
      passwordFile = builtins.toString ./secrets/password;
      extraBackupArgs = [
        "--tag"
        name
      ];
    };
in
{
  services.restic = {
    enable = true;
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
}
