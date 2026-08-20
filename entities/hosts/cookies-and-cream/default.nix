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
    config = ./configuration.nix;
    traits = with config.lab.traits; [
      attributes.nixos
      attributes.container-host
      attributes.public-facing
      attributes.ssh-server
      attributes.user-tyler

      services.mesh-vpn
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
