{ ... }:
{
  flake.nixosTraits.mesh-vpn =
    { config, ... }:
    {
      services.tailscale.enable = true;

      sops.secrets.mesh-vpn = {
        sopsFile = ./secrets/key.yaml;
        key = "key";
      };

      services.netbird.clients.wt0 = {
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
}
