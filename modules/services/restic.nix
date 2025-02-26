{
  self,
  pkgs,
  props,
  ...
}:

{
  environment.systemPackages = [
    pkgs.restic
  ];

  services.restic.backups = {
    cloud = {
      initialize = true;

      paths = [
        props.backup.apps.directory
        props.backup.data.directory
      ];

      timerConfig = {
        OnCalendar = "01:00";
        Persistent = true;
      };

      pruneOpts = [
        "--keep-daily 3"
        "--keep-weekly 3"
        "--keep-monthly 3"
        "--keep-yearly 3"
      ];

      repositoryFile = "${self}/secrets/backup/repository";
      environmentFile = "${self}/secrets/backup/environment";
      passwordFile = "${self}/secrets/backup/password";
    };
  };
}
