{ ... }:
{
  flake.nixosTraits.dns =
    { mounts, ... }:
    let
      data = "${mounts.config}/pihole/etc-pihole";
      dnsmasq = "${mounts.config}/pihole/etc-dnsmasq";
    in
    {
      virtualisation.docker-compose.dns = {
        file = ./docker-compose.yaml;
        env = {
          PIHOLE_VERSION = "2025.08.0";
          TIMEZONE = "America/Chicago";
          PASSWORD = builtins.readFile ./secrets/password;
          TS_AUTHKEY = builtins.readFile ./secrets/authkey;
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
    };
}
