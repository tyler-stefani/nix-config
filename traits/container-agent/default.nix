{ ... }:
{
  lab.traits.manages.container-agent.nixos = { ... }: {
    virtualisation.docker-stack.container-agent = {
      file = ./docker-compose.yaml;
    };
  };
}
