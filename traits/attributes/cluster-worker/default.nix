{ ... }:
{
  lab.traits.attributes.cluster-worker.nixos =
    { ... }:
    {
      virtualisation.docker-swarm.enable-worker = true;
    };
}
