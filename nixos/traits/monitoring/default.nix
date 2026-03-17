{ ... }:
{
  flake.nixosTraits.hosts.monitoring =
    {
      config,
      lib,
      ...
    }:
    {
      sops.secrets."monitoring/domain" = {
        sopsFile = ./secrets/secrets.yaml;
        key = "domain";
      };
      sops.envs.monitoring = {
        sopsFile = secrets/.env;
      };
      sops.templates."monitoring/domain".content = ''
        ${config.sops.placeholder."monitoring/domain"}
      '';
      services.grafana = {
        enable = true;
        openFirewall = true;
        settings = {
          server = {
            domain = config.sops.templates."monitoring/domain".content;
            http_addr = "0.0.0.0";
          };
          auth = {
            oauth_auto_login = false;
          };
          "auth.generic_oauth" = {
            enabled = true;
          };
        };
      };
      systemd.services.grafana.serviceConfig.EnvironmentFile = config.sops.envs.monitoring.path;
    };
}
