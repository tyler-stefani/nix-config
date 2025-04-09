{ self, ... }:
{
  services.restic = {
    enable = true;
    backups.cloud = {
      initialize = true;
      paths = [
        "/home/tyler/shared/safe"
      ];
      timerConfig = {
        OnCalendar = "01:00";
        Persistent = true;
      };
      repositoryFile = "${self}/secrets/backup/repository";
      environmentFile = "${self}/secrets/backup/environment";
      passwordFile = "${self}/secrets/backup/password";
    };
  };
}
