{ ... }:
{
  flake.nixosTraits.containers =
    { lib, config, ... }:
    {
      virtualisation = {
        docker.enable = true;
        oci-containers.backend = "docker";
        docker-stack.containers = lib.mkIf config.virtualisation.docker-swarm.enable-manager {
          file = ./docker-compose.yaml;
        };
      };
    };
}
