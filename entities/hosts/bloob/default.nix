{ inputs, config, ... }:
{
  lab.entities.hosts.bloob = {
    system = "x86_64-linux";
    config = ./configuration.nix;
    traits = with config.lab.traits; [
      attributes.nixos
      attributes.ssh-server
      attributes.user-tyler

      programs.desktop-environment
      programs.games
    ];
  };
}
