{
  inputs,
  config,
  ...
}:
{
  lab.entities.hosts.cookies-and-cream = {
    system = "x86_64-linux";
    config = ./configuration.nix;
  };
}
