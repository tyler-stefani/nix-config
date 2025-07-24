{ self, ... }:
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  virtualisation.docker-compose.proxy = {
    dir = self + /stacks/proxy;
  };
}
