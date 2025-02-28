{ config, lib, ... }:

{

  options = {
    tailscale.enable = lib.mkEnableOption "Whether to add this machine to the tailnet";
  };

  config = lib.mkIf config.tailscale.enable {
    services.tailscale.enable = true;

    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      allowedTCPPorts = [ 22 ];
    };
  };
}
