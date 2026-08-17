{
  inputs,
  config,
  ...
}:
{
  lab.entities.hosts.coconut = {
    system = "x86_64-linux";
    config = ./configuration.nix;
    traits =
      {
        is,
        has,
        hosts,
        manages,
        ...
      }:
      [
        is.nixos
        is.container-host
        is.mesh-node
        is.cluster-manager
        is.ssh-server

        has.user-tyler
        has.backups
        has.metrics

        hosts.dns
        hosts.drive
        hosts.feed
        hosts.keep
        hosts.local-media
        hosts.media
        hosts.monitoring
        hosts.container-monitoring
        hosts.notes
        hosts.photos
        hosts.proxy
        hosts.records

        manages.container-agent
      ];
    mounts = {
      data = "/home/tyler/shared/safe/data";
      config = "/home/tyler/apps";
      media = "/home/tyler/shared/media";
      fast = "/home/tyler/fast";
    };
    networking = {
      ips = {
        dns = "192.168.1.201";
        macvlan-shim = "192.168.1.211";
      };
      macs = {
        dns = "02:00:00:00:00:69";
        macvlan-shim = "02:00:00:00:01:69";
      };
      interfaces.primary = "eno1";
    };
    deploy = {
      username = "tyler";
      hostname = "192.168.1.69";
    };
  };
}
