{ ... }:
{

  lab.traits.services.container-agent.nixos = {
    hostname = "agent";
    module = { ... }: {
      virtualisation.docker-stack.container-agent = {
        file = ./docker-compose.yaml;
      };
    };
  };
}
