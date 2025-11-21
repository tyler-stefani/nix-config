{ ... }:
{
  flake.nixosTraits.dns =
    {
      config,
      mounts,
      ips,
      ...
    }:
    let
      data = "${mounts.config}/pihole/etc-pihole";
      dnsmasq = "${mounts.config}/pihole/etc-dnsmasq";
    in
    {
      sops.envs.dns = {
        sopsFile = secrets/.env;
      };
      virtualisation.docker-compose.dns = {
        file = ./docker-compose.yaml;
        env = {
          PIHOLE_VERSION = "2025.08.0";
          TIMEZONE = "America/Chicago";
          DATA_DIR = data;
          DNSMASQ_DIR = dnsmasq;
          PIHOLE_IP = ips.dns;
        };
        envPath = config.sops.envs.dns.path;
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
