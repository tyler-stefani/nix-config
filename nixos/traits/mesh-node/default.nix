{ ... }:
{
  flake.nixosTraits.is.mesh-node =
    { nixpkgs-unstable, config, ... }:
    {
      sops.secrets.mesh-node = {
        sopsFile = ./secrets/key.yaml;
        key = "key";
      };
      services.netbird = {
        package = nixpkgs-unstable.netbird;
        clients.wt0 = {
          port = 51820;
          # login is not working on this version
          # - there is currently no way to set the management url
          # - the docker sock opened does not line up with the default for netbird up
          # login = {
          #   enable = true;
          #   setupKeyFile = "${config.sops.secrets.mesh-vpn.path}";
          # };
        };
      };
    };
}
