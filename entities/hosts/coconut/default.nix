{
  inputs,
  config,
  ...
}:
let
  cfg = config.lab.entities.hosts.coconut;
in
{
  lab.entities.hosts.coconut = {
    system = "x86_64-linux";
    config = ./configuration.nix;
    traits = with config.lab.traits; [
      attributes.nixos
      attributes.container-host
      attributes.mesh-node
      attributes.cluster-manager
      attributes.ssh-server
      attributes.user-tyler

      programs.backups
      programs.metrics

      services.dns
      services.drive
      services.feed
      services.keep
      services.local-media
      services.media
      services.monitoring
      services.container-monitoring
      services.notes
      services.photos
      services.proxy
      services.records
      services.container-agent
    ];
    mounts = {
      data = "/home/tyler/shared/safe/data";
      config = "/home/tyler/apps";
      media = "/home/tyler/shared/media";
      fast = "/home/tyler/fast";
    };
    networking = {
      ips = {
        self = "192.168.1.69";
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
      enable = true;
      username = "tyler";
      hostname = cfg.networking.ips.self;
    };
  };
}
