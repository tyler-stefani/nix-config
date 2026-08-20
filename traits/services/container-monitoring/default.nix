{ ... }:
{

  lab.traits.services.container-monitoring.nixos = {
    hostname = "containers";
    module = { ... }: {
      virtualisation.docker-compose.container-monitoring = {
        file = ./docker-compose.yaml;
      };
    };
  };
}
