{ self, props, ... }:
{
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
        "${props.homeServer.directory}/tailscale/state:/var/lib/tailscale"
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
        TZ = props.timezone;
        WEBPASSWORD = builtins.readFile "${self}/secrets/dns/password";
      };
      volumes = [
        "${props.homeServer.directory}/pihole/etc-pihole:/etc/pihole"
        "${props.homeServer.directory}/pihole/etc-dnsmasq:/etc/dnsmasq.d"
      ];
      networks = [
        props.networks.vlan.name
      ];
      extraOptions = [
        "--ip"
        "192.168.0.200"
        "--dns"
        "9.9.9.9"
      ];
    };
  };
}
