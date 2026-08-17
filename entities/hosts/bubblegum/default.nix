{ inputs, config, ... }:
{
  lab.entities.hosts.bubblegum = {
    system = "x86_64-linux";
    config = ./configuration.nix;
    traits =
      {
        is,
        has,
        hosts,
        ...
      }:
      [
        is.nixos
        is.container-host
        is.mesh-node
        is.cluster-worker
        is.ssh-server

        has.user-tyler
        has.backups
        has.metrics

        hosts.auth
        hosts.dash
        hosts.dns
        hosts.home-automation
        hosts.search
        hosts.wiki
      ];
    mounts = {
      config = "/home/tyler/apps";
      data = "/home/tyler/shared/safe/data";
    };
    networking = {
      ips = {
        dns = "192.168.1.200";
        macvlan-shim = "192.168.1.210";
      };
      macs = {
        dns = "02:00:00:00:00:68";
        macvlan-shim = "02:00:00:00:01:68";
      };
      interfaces.primary = "enp1s0";
    };
    deploy = {
      username = "tyler";
      hostname = "192.168.1.68";
    };
  };
}
