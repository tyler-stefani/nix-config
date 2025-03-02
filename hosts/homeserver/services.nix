{ self, ... }:
{
  services = {
    tailscale.enable = true;

    piholeOCI = {
      enable = true;
      dataDir = "/home/tyler/homeserver";
      ip = "192.168.0.200";
    };
    nginxOCI = {
      enable = true;
      dataDir = "/home/tyler/homeserver";
    };

    portainerOCI = {
      enable = true;
      dataDir = "/home/tyler/homeserver";
    };

    restic = {
      enable = true;
      backups.cloud = {
        initialize = true;
        paths = [
          "/home/tyler/backup/apps"
          "/home/tyler/backup/data"
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
  };
}
