{ ... }:
{
  lab.traits.has.coding-agent.home =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      services.podman.enable = true;

      programs.opencode = {
        enable = true;
        package = pkgs.writeShellScriptBin "occ" ''
          export PATH="${
            pkgs.lib.makeBinPath [
              pkgs.podman
              pkgs.coreutils
            ]
          }:$PATH"
          exec ${pkgs.fish}/bin/fish ${./occ.fish} "$@"
        '';
        settings = {
          model = "opencode/mimo-v2.5-free";
          autoupdate = false;
          permission = {
            "*" = "allow";
            edit = "ask";
            webfetch = "allow";
            external_directory = "ask";
            bash = {
              "*" = "allow";
              "rm *" = "ask";
              "rmdir *" = "ask";
            };
          };
        };
      };

      stylix.targets.opencode.enable = lib.mkIf config.stylix.enable true;

      # can probably be removed with stylix 26.05
      xdg.configFile."opencode/tui.json".text = builtins.toJSON {
        "$schema" = "https://opencode.ai/tui.json";
        theme = "stylix";
      };
    };
}
