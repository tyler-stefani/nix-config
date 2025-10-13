{ ... }:
{
  flake.nixosTraits.mesh-vpn =
    { ... }:
    {
      services.tailscale.enable = true;
    };
}
