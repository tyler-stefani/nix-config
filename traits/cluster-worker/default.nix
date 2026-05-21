{ ... }:
{
  lab.traits.is.cluster-worker.nixos =
    { ... }:
    {
      virtualisation.docker-swarm.enable-worker = true;
    };
}
