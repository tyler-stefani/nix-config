{ ... }:
{
  lab.traits.is.cluster-manager.nixos =
    { ... }:
    {
      virtualisation.docker-swarm.enable-manager = true;
    };
}
