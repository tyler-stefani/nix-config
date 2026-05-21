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
      ];
    mounts = {
      config = "/home/tyler/apps";
      data = "/home/tyler/shared/safe/data";
    };
    ips.dns = "192.168.0.201";
  };
}
