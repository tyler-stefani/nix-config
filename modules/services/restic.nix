{
  self,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.restic;
in
{
  options = {
    restic = {
      enable = mkEnableOption "a backup service";
      paths = mkOption {
        type = types.listOf types.path;
        default = [ ];
      };
      keepSnapshots = {
        daily = mkOption {
          type = types.ints.unsigned;
          default = 3;
        };
        weekly = mkOption {
          type = types.ints.unsigned;
          default = 3;
        };
        monthly = mkOption {
          type = types.ints.unsigned;
          default = 3;
        };
        yearly = mkOption {
          type = types.ints.unsigned;
          default = 3;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.restic
    ];

    services.restic.backups = {
      cloud = {
        initialize = true;

        paths = cfg.paths;

        timerConfig = {
          OnCalendar = "01:00";
          Persistent = true;
        };

        pruneOpts = [
          "--keep-daily ${toString cfg.keepSnapshots.daily}"
          "--keep-weekly ${toString cfg.keepSnapshots.weekly}"
          "--keep-monthly ${toString cfg.keepSnapshots.monthly}"
          "--keep-yearly ${toString cfg.keepSnapshots.yearly}"
        ];

        repositoryFile = "${self}/secrets/backup/repository";
        environmentFile = "${self}/secrets/backup/environment";
        passwordFile = "${self}/secrets/backup/password";
      };
    };
  };
}
