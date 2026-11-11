{ ... }:
{
  lab.traits.programs.coding-agent.home =
    { ... }:
    {
      programs.pi.enable = true;
      programs.pi.extensions = [
        ./pi-extensions/sidebar.ts
        "pi-web-access"
      ];
      programs.pi.instructions = [ ./AGENTS.md ];
    };
}
