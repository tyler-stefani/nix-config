{
  inputs,
  config,
  ...
}:
{
  lab.entities.hosts.cookies-and-cream = {
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
        is.public-facing
        is.ssh-server

        has.user-tyler

        hosts.mesh-vpn
      ];
    mounts = {
      config = "/home/tyler/apps";
    };
  };
}
