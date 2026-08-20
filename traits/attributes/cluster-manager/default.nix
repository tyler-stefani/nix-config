{ ... }:
{
  lab.traits.attributes.cluster-manager.nixos =
    { ... }:
    {
      virtualisation.docker-swarm.enable-manager = true;
    };
}
