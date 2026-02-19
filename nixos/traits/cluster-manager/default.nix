{ ... }:
{
  flake.nixosTraits.cluster-manager =
    { ... }:
    {
      virtualisation.docker-swarm.enable-manager = true;

    };
}
