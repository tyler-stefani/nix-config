{ inputs, config, ... }:
{
  lab.entities.hosts.bloob = {
    system = "x86_64-linux";
    config = ./configuration.nix;
  };
}
