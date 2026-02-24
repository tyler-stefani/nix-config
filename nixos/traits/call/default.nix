{ ... }:
{
  flake.nixosTraits.call =
    { config, mounts, ... }:
    {
      sops.envs.call = {
        sopsFile = ./secrets/.env;
      };
      virtualisation.docker-compose.call = {
        file = ./docker-compose.yaml;
        env = {
          CONFIG_DIR = "${mounts.config}/element-call";
        };
        envPath = config.sops.envs.call.path;
      };
      networking.firewall = {
        allowedTCPPorts = [ 7881 ];
        allowedUDPPortRanges = [
          {
            from = 50100;
            to = 50200;
          }
        ];
      };
    };
}
