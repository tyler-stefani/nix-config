{ inputs, config, ... }:
{
  lab.entities.hosts.bubblegum = {
    system = "x86_64-linux";
    config = ./configuration.nix;
  };
}
