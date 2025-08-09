{ config, lib, ... }:
{
  services = {
    prometheus = {
      enable = true;
      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
            }
          ];
        }
        {
          job_name = "restic";
          static_configs = [
            {
              targets = [ "localhost:${toString config.services.prometheus.exporters.restic.port}" ];
            }
          ];
        }
      ];
      exporters.node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
      exporters.restic = lib.mkIf config.services.restic.enable {
        enable = true;
        repositoryFile = config.services.restic.backups.notes.repositoryFile;
        passwordFile = config.services.restic.backups.notes.passwordFile;
        environmentFile = config.services.restic.backups.notes.environmentFile;
        refreshInterval = 21600;
      };
    };
    grafana = {
      enable = true;
      settings.server = {
        domain = "monitoring.peebo.world";
        http_addr = "0.0.0.0";
      };
    };
  };
}
