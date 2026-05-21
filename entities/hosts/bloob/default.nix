{ inputs, config, ... }:
{
  lab.entities.hosts.bloob = {
    system = "x86_64-linux";
    config = ./configuration.nix;
    traits =
      { is, has, ... }:
      [
        is.nixos
        is.ssh-server

        has.user-tyler
        has.desktop-environment
        has.games
      ];
  };
}
