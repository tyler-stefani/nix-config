{ ... }:
{

  lab.traits.services.uptime-monitoring.nixos = {
    hostname = "uptime";
    module =
      { config, mounts, ... }:
      {
        virtualisation.docker-compose.uptime-monitoring = {
          file = ./docker-compose.yaml;
          env = {
            DATA_DIR = "${mounts.config}/uptime-kuma";
          };
        };
      };
  };
}
