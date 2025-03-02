{
  self,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.services.piholeOCI;
  vlan = config.networking.oci.networks.ipvlan;
in
{
  options.services.piholeOCI = {
    enable = mkEnableOption "Pi-hole via oci container";
    ip = mkOption {
      type = types.str;
    };
    dataDir = mkOption {
      type = types.str;
    };
    timeZone = mkOption {
      type = types.str;
      default = "America/Chicago";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      hole-sidecar = {
        image = "tailscale/tailscale:latest";
        environment = {
          TS_AUTHKEY = (builtins.readFile "${self}/secrets/dns/authkey") + "?ephemeral=false";
          TS_EXTRA_ARGS = "--advertise-tags=tag:container";
          TS_STATE_DIR = "/var/lib/tailscale";
          TS_USERSPACE = "false";
        };
        volumes = [
          "${cfg.dataDir}/tailscale/state:/var/lib/tailscale"
          "/dev/net/tun:/dev/net/tun"
        ];
        capabilities = {
          NET_ADMIN = true;
          SYS_MODULE = true;
        };
        networks = [
          "container:hole"
        ];
        dependsOn = [
          "hole"
        ];
        privileged = true;
      };
      hole = {
        image = "pihole/pihole:latest";
        hostname = "hole";
        environment = {
          TZ = cfg.timeZone;
          WEBPASSWORD = builtins.readFile "${self}/secrets/dns/password";
        };
        volumes = [
          "${cfg.dataDir}/pihole/etc-pihole:/etc/pihole"
          "${cfg.dataDir}/pihole/etc-dnsmasq:/etc/dnsmasq.d"
        ];
        networks = [
        ] ++ (lists.optional vlan.enable vlan.name);
        extraOptions =
          [
            "--dns"
            "9.9.9.9"
          ]
          ++ (lists.optionals vlan.enable [
            "--ip"
            cfg.ip
          ]);
      };
    };
  };
}
