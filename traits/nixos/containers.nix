{ flakePath, ... }:
{
  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
    docker-compose.containers = {
      dir = flakePath + /stacks/containers;
    };
  };
}
