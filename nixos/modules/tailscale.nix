{ ... }:
{
  flake.nixosModules.tailscale =
    { config, lib, ... }:
    let
      cfg = config.services.tailscale;
    in
    {
      config = lib.mkIf cfg.enable {
        networking.firewall = {
          trustedInterfaces = [ cfg.interfaceName ];
          allowedUDPPorts = [ cfg.port ];
          allowedTCPPorts = [ 22 ];
        };
      };
    };
}
