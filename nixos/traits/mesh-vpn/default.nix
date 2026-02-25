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

      services.netbird.clients.default = {
        login = {
          enable = true;
          setupKeyFile = "${config.sops.secrets.mesh-vpn.path}";
        };
      };
    };
}
