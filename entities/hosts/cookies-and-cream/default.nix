{
  inputs,
  config,
  ...
}:
let
  cfg = config.lab.entities.hosts.cookies-and-cream;
in
{
  lab.entities.hosts.cookies-and-cream = {
    system = "x86_64-linux";
    config = config.lab.traits.attributes.cookies-and-cream.nixos;
    traits = with config.lab.traits; [
      attributes.nixos
      attributes.container-host
      attributes.mesh-node
      attributes.public-facing
      attributes.ssh-server
      attributes.user-tyler

      programs.backups

      services.mesh-vpn
      services.uptime-monitoring
    ];
    mounts = {
      config = "/home/tyler/apps";
    };
    networking.ips.self = "23.95.220.100";
    deploy = {
      enable = true;
      username = "tyler";
      hostname = cfg.networking.ips.self;
    };
  };
}
