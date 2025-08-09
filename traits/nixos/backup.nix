{ self, ... }:
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
      repositoryFile = "${self}/secrets/backup/repository";
      environmentFile = "${self}/secrets/backup/environment";
      passwordFile = "${self}/secrets/backup/password";
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
        path = "/home/tyler/shared/safe/data/notes";
      };
      records = mkBackup {
        name = "records";
        path = "/home/tyler/shared/safe/data/records";
      };
    };
  };
}
