{ ... }:
{
  flake.nixosTraits.is.cluster-worker =
    { ... }:
    {
      virtualisation.docker-swarm.enable-worker = true;
    };
}
