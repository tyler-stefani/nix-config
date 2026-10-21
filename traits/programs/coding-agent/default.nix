{ ... }:
{
  lab.traits.programs.coding-agent.home =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      programs.pi.enable = true;
      programs.pi.extensions = [
        ./pi-extensions/sidebar.ts
      ];
      programs.pi.instructions = [ ./AGENTS.md ];
    };
}
