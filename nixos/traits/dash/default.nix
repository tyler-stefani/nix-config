{ ... }:
{
  flake.nixosTraits.dash =
    { config, ... }:
    {
      sops.envs.dash = {
        sopsFile = ./secrets/.env;
      };
      virtualisation.docker-compose.dash = {
        file = ./docker-compose.yaml;
        envPath = config.sops.envs.dash.path;
      };
    };
}
