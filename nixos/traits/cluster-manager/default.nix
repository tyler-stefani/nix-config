{ ... }:
{
  flake.nixosTraits.is.cluster-manager =
    { ... }:
    {
      virtualisation.docker-swarm.enable-manager = true;
    };
}
