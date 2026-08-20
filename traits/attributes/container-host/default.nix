{ ... }:
{
  lab.traits.attributes.container-host.nixos =
    { lib, config, ... }:
    {
      virtualisation = {
        docker.enable = true;
        oci-containers.backend = "docker";
      };
    };
}
