{ self, config, ... }:
{
  services.prometheus = {
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
    exporters.restic = {
      enable = true;
      repositoryFile = config.services.restic.backups.cloud.repositoryFile;
      passwordFile = config.services.restic.backups.cloud.passwordFile;
      environmentFile = config.services.restic.backups.cloud.environmentFile;
      refreshInterval = 21600;
    };
  };

  services.grafana = {
    enable = true;
    settings.server = {
      domain = (self + /secrets/monitoring/domain);
      http_addr = "0.0.0.0";
    };
  };

  networking.firewall.allowedTCPPorts = [ 3000 ];
}
