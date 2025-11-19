{ ... }:
{
  flake.nixosTraits.dash =
    { ... }:
    {
      sops.secrets."dash/.env" = {
        format = "dotenv";
        sopsFile = ./secrets/.env;
        key = "";
      };
      virtualisation.docker-compose.dash = {
        file = ./docker-compose.yaml;
        envPath = "/run/secrets/dash/.env";
      };
    };
}
