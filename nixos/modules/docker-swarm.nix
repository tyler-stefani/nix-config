{ ... }:
{
  flake.nixosModules.docker-swarm =
    { lib, config, ... }:
    with lib;
    {
      options.virtualisation.docker-swarm = {
        enable-manager = mkEnableOption "initialization of a docker swarm as a manager";
        enable-worker = mkEnableOption "joining a docker swarm as a worker";
      };

      config =
        let
          cfg = config.virtualisation.docker-swarm;
        in
        lib.mkIf (cfg.enable-manager || cfg.enable-worker) {
          networking.firewall = {
            allowedTCPPorts = [
              2377
              7946
            ];
            allowedUDPPorts = [
              7946
              4789
            ];
          };
        };
    };
}
