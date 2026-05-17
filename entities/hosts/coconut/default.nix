{
  inputs,
  config,
  ...
}:
{
  lab.entities.hosts.coconut = {
    system = "x86_64-linux";
    config = ./configuration.nix;
  };
}
