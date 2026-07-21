{ ... }:
{
  lab.traits.hosts.container-monitoring.nixos = { ... }: {
    virtualisation.docker-compose.container-monitoring = {
      file = ./docker-compose.yaml;
    };
  };
}
