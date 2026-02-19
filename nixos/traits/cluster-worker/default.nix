{ ... }:
{
  flake.nixosTraits.cluster-worker =
    { ... }:
    {
      virtualisation.docker-swarm.enable-worker = true;
    };
}
