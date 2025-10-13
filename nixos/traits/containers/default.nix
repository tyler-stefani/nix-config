{ ... }:
{
  flake.nixosTraits.containers =
    { ... }:
    {
      virtualisation = {
        docker.enable = true;
        oci-containers.backend = "docker";
        docker-compose.containers = {
          file = ./docker-compose.yaml;
        };
      };
    };
}
