{ ... }:
{
  flake.nixosTraits.is.public-facing =
    { config, ... }:
    {
      sops.secrets.public-facing = {
        sopsFile = ./secrets/key.yaml;
        key = "key";
      };
      services.crowdsec-firewall-bouncer = {
        enable = true;
        secrets.apiKeyPath = config.sops.secrets.public-facing.path;
        settings = {
          api_url = "http://127.0.0.1:8080";
        };
      };

    };
}
