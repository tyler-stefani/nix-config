{ ... }:
{
  lab.traits.hosts.dns.nixos =
    {
      config,
      pkgs,
      mounts,
      networking,
      ...
    }:
    let
      configDir = "${mounts.config}/technitium/config";
      backupDir = "${mounts.config}/technitium/backups";

      backupScript = pkgs.buildGoModule {
        pname = "technitium-backup";
        version = "0.1.0";
        src = ./backups;
        vendorHash = null;
      };
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

      sops.secrets."dns/api-token" = {
        sopsFile = ./secrets/secrets.yaml;
        key = "api-token";
      };

      services.restic.zeroDowntimeBackups.dns = {
        prepareCommand =
          "${backupScript}/bin/technitium-backup"
          + " --url http://${networking.ips.dns}:5380"
          + " --token-file ${config.sops.secrets."dns/api-token".path}"
          + " --out ${backupDir}/technitium-backup.zip";
        paths = [
          backupDir
        ];
        timerConfig = {
          OnCalendar = "Mon *-*-* 03:30";
          Persistent = true;
        };
      };
    };
}
