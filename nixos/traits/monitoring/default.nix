{ ... }:
{
  flake.nixosTraits.hosts.monitoring =
    {
      config,
      lib,
      ...
    }:
    {
      sops.envs.monitoring = {
        sopsFile = secrets/.env;
      };
      services.grafana = {
        enable = true;
        openFirewall = true;
        settings = {
          server = {
            http_addr = "0.0.0.0";
          };
          auth = {
            oauth_auto_login = false;
          };
          "auth.generic_oauth" = {
            enabled = true;
            scopes = "openid email profile";
          };
        };
      };
      systemd.services.grafana.serviceConfig.EnvironmentFile = config.sops.envs.monitoring.path;
    };
}
