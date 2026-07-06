{ ... }:
{
  flake.homeModules.pi =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    with lib;
    let
      cfg = config.programs.pi;

      linkFilesIn =
        type: files:
        listToAttrs (
          map (f: {
            name = ".pi/agent/${type}/${builtins.baseNameOf f}";
            value = {
              source = f;
            };
          }) files
        );

      linkedFiles =
        linkFilesIn "extensions" cfg.extensions
        // linkFilesIn "themes" cfg.themes
        // linkFilesIn "prompts" cfg.prompts
        // linkFilesIn "skills" cfg.skills;

    in
    {
      options.programs.pi = {
        enable = mkEnableOption "pi coding agent";

        package = mkPackageOption pkgs "pi-coding-agent" { };

        extensions = mkOption {
          type = types.listOf types.path;
          default = [ ];
          example = [ ./my-extension.ts ];
          description = ''
            Extensions to symlink into ~/.pi/agent/extensions/.
            Files are linked by their basename.
          '';
        };

        themes = mkOption {
          type = types.listOf types.path;
          default = [ ];
          example = [ ./my-theme.json ];
          description = ''
            Themes to symlink into ~/.pi/agent/themes/.
            Files are linked by their basename.
          '';
        };

        prompts = mkOption {
          type = types.listOf types.path;
          default = [ ];
          example = [ ./review-prompt.md ];
          description = ''
            Prompt templates to symlink into ~/.pi/agent/prompts/.
            Files are linked by their basename.
          '';
        };

        skills = mkOption {
          type = types.listOf types.path;
          default = [ ];
          example = [ ./my-skill ];
          description = ''
            Skills to symlink into ~/.pi/agent/skills/.
            Files are linked by their basename.
          '';
        };
      };

      config = mkIf cfg.enable {
        home.file = linkedFiles;
        home.packages = optional (cfg.package != null) cfg.package;
      };
    };
}
