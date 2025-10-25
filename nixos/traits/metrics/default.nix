{ ... }:
{
  flake.nixosTraits.metrics =
    {
      config,
      lib,
      ...
    }:
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
        ]
        ++ (lib.lists.optionals config.services.restic.enable [
          {
            job_name = "restic";
            static_configs = [
              {
                targets = [ "localhost:${toString config.services.prometheus.exporters.restic.port}" ];
              }
            ];
          }
        ]);
        exporters = {
          node = {
            enable = true;
            enabledCollectors = [ "systemd" ];
          };

          restic = lib.mkIf config.services.restic.enable {
            enable = true;
            repositoryFile = config.services.restic.defaultRepositoryFile;
            passwordFile = config.services.restic.defaultPasswordFile;
            environmentFile = config.services.restic.defaultEnvironmentFile;
            refreshInterval = 21600;
          };
        };
      };

      networking.firewall.allowedTCPPorts = [ 9090 ];
    };
}
