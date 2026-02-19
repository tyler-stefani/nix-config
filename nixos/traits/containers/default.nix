{ ... }:
{
  flake.nixosTraits.containers =
    { ... }:
    {
      virtualisation = {
        docker.enable = true;
        oci-containers.backend = "docker";
        docker-stack.containers = {
          file = ./docker-compose.yaml;
        };
      };
    };
}
