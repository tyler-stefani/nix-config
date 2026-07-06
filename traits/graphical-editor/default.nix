{ ... }:
{
  lab.traits.has.graphical-editor.home =
    { pkgs, ... }:
    {
      programs.vscodium = {
        enable = true;
        profiles.default = {
          extensions = with pkgs.vscode-extensions; [
            jnoortheen.nix-ide
            bmalehorn.vscode-fish
          ];
          userSettings = {
            "editor.formatOnSave" = true;
            "files.autosave" = "onFocusChange";
            "window.titleBarStyle" = "custom";
          };
        };
        argvSettings = {
          "disable-hardware-acceleration" = true;
        };
      };

      systemd.user.sessionVariables.NIXOS_OZONE_WL = "1";

      stylix.targets = {
        vscodium.enable = true;
      };
    };
}
