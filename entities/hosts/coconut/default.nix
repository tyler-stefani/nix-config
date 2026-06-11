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
        hosts.minecraft
        hosts.monitoring
        hosts.notes
        hosts.photos
        hosts.proxy
        hosts.records
      ];
    mounts = {
      data = "/home/tyler/shared/safe/data";
      config = "/home/tyler/apps";
      media = "/home/tyler/shared/media";
      fast = "/home/tyler/fast";
    };
    ips.dns = "192.168.0.200";
  };
}
