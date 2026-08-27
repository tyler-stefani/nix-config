{ ... }:
{
  lab.traits.attributes.mesh-node.nixos =
    { nixpkgs-unstable, config, ... }:
    {
      sops.secrets.mesh-node = {
        sopsFile = ./secrets/key.yaml;
        key = "key";
      };
      services.resolved.enable = true;
      services.netbird = {
        package = nixpkgs-unstable.netbird;
        clients.wt0 = {
          port = 51820;
        };
      };
    };
}
