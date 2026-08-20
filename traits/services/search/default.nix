{ ... }:
{

  lab.traits.services.search.nixos = {
    hostname = "search";
    module =
      { config, mounts, ... }:
      {
        virtualisation.docker-compose.search = {
          file = ./docker-compose.yaml;
          env = {
            DATA_DIR = "${mounts.config}/degoog";
          };
        };
      };
  };
}
