{ ... }:
{
  flake.nixosTraits.monitoring =
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
      sops.templates."monitoring/domain".content = ''
        ${config.sops.placeholder."monitoring/domain"}
      '';
      services.grafana = {
        enable = true;
        settings.server = {
          domain = config.sops.templates."monitoring/domain".content;
          http_addr = "0.0.0.0";
        };
      };
      networking.firewall.allowedTCPPorts = [ 3000 ];
    };
}
