{ ... }:
{
  imports = [
    ./docker-compose.nix
    ./fish.nix
    ./oci.nix
    ./restic.nix
    ./syncthing.nix
    ./tailscale.nix
  ];
}
