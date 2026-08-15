{ ... }:
{
  lab.traits.hosts.dns.nixos =
    {
      config,
      mounts,
      networking,
      ...
    }:
    let
      configDir = "${mounts.config}/technitium";
    in
    {
      virtualisation.docker-compose.dns = {
        file = ./docker-compose.yaml;
        env = {
          TECHNITIUM_VERSION = "15.4.0";
          TZ = "America/Chicago";
          CONFIG_DIR = configDir;
          BIND_IP = networking.ips.dns;
          BIND_MAC = networking.macs.dns;
          PARENT_INTERFACE = networking.interfaces.primary;
        };
      };

      networking.macvlans.dns-shim = {
        interface = networking.interfaces.primary;
        mode = "bridge";
      };

      networking.interfaces.dns-shim = {
        macAddress = networking.macs.macvlan-shim;
        ipv4 = {
          addresses = [
            {
              address = networking.ips.macvlan-shim;
              prefixLength = 32;
            }
          ];
          routes = [
            {
              address = networking.ips.dns;
              prefixLength = 32;
            }
          ];
        };
      };
    };
}
