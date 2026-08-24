{ ... }:
{
  lab.traits.services.monitoring.nixos =
    {
      config,
      lib,
      ...
    }:
    {
      sops.envs.monitoring = {
        sopsFile = ./secrets/.env;
      };
      services.grafana = {
        enable = true;
        openFirewall = true;
        settings = {
          server = {
            http_addr = "0.0.0.0";
          };
          security = {
            secret_key = "SW2YcwTIb9zpOOhoPsMm";
          };
          auth = {
            oauth_auto_login = false;
          };
          "auth.generic_oauth" = {
            enabled = true;
            scopes = "openid email profile";
          };
          security.secret_key = "SW2YcwTIb9zpOOhoPsMm";
        };
      };
      systemd.services.grafana.serviceConfig.EnvironmentFile = config.sops.envs.monitoring.path;

      services.restic.backups.monitoring =
        let
          cfg = config.services.restic;
        in
        {
          initialize = true;
          paths = [ "/var/lib/grafana" ];
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
            "monitoring"
          ];
        };
    };
}
