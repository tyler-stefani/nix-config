{ self, ... }:
{
  config.virtualisation.docker-compose.minecraft = {
    dir = self + /stacks/minecraft;
  };
}
