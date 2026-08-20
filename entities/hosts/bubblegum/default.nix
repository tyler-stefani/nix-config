{
  inputs,
  config,
  ...
}:
let
  cfg = config.lab.entities.hosts.bubblegum;
in
{
  lab.entities.hosts.bubblegum = {
    system = "x86_64-linux";
    config = ./configuration.nix;
    traits = with config.lab.traits; [
      attributes.nixos
      attributes.container-host
      attributes.mesh-node
      attributes.cluster-worker
      attributes.ssh-server
      attributes.user-tyler

      programs.backups
      programs.metrics

      services.auth
      services.dash
      services.dns
      services.home-automation
      services.search
      services.wiki
    ];
    mounts = {
      config = "/home/tyler/apps";
      data = "/home/tyler/shared/safe/data";
    };
    networking = {
      ips = {
        self = "192.168.1.68";
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
      enable = true;
      username = "tyler";
      hostname = cfg.networking.ips.self;
    };
  };
}
