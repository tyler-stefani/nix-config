{ self, ... }:
let
  data = "/home/tyler/apps/pihole/etc-pihole";
  dnsmasq = "/home/tyler/apps/pihole/etc-dnsmasq";
in
{
  virtualisation.docker-compose.dns = {
    dir = self + /stacks/dns;
    env = {
      PIHOLE_VERSION = "2025.08.0";
      TIMEZONE = "America/Chicago";
      PASSWORD = builtins.readFile "${self}/secrets/dns/password";
      TS_AUTHKEY = builtins.readFile "${self}/secrets/dns/authkey";
      DATA_DIR = data;
      DNSMASQ_DIR = dnsmasq;
    };
    /*
      This does not work because the cloud backup can not be reached when pihole is down
      backup = {
        enable = true;
        paths = [ ];
        timerConfig = {
          OnCalendar = "Mon *-*-* 01:00";
          Persistent = true;
        };
      };
    */
  };
}
