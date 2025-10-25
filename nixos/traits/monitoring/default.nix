{ ... }:
{
  flake.nixosTraits.monitoring =
    {
      config,
      lib,
      ...
    }:
    {
      services.grafana = {
        enable = true;
        settings.server = {
          domain = builtins.readFile ./secrets/domain;
          http_addr = "0.0.0.0";
        };
      };
      networking.firewall.allowedTCPPorts = [ 3000 ];
    };
}
