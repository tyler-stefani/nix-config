{ ... }:
{
  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
    docker-compose = { };
  };

  services.portainerOCI = {
    enable = true;
    dataDir = "/home/tyler/apps";
  };
}
