{ ... }:
{
  flake.nixosModules.restic =
    {
      lib,
      config,
      pkgs,
      utils,
      ...
    }:
    let
      cfg = config.services.restic;
    in
    with lib;
    {
      options.services.restic = {
        enable = mkEnableOption "a scheduled backup service";

        defaultRepositoryFile = mkOption {
          type = with lib.types; nullOr path;
          default = null;
          description = ''
            Default path to file containing the repository location to backup to for all backups.
          '';
        };

        defaultEnvironmentFile = mkOption {
          type = with lib.types; nullOr str;
          default = null;
          description = ''
            Default file containing the credentials to access the repository for all backups,
            in the format of an EnvironmentFile as described by {manpage}`systemd.exec(5)`.
          '';
        };

        defaultPasswordFile = mkOption {
          type = lib.types.str;
          description = ''
            Default file to read the repository password from for all backups.
          '';
          example = "/etc/nixos/restic-password";
        };

        backups = mkOption {
          type = types.attrsOf (
            types.submodule (
              { name, config, ... }:
              {
                options = {
                  snapshotsToKeep = {
                    daily = mkOption {
                      type = types.ints.unsigned;
                      default = 3;
                    };
                    weekly = mkOption {
                      type = types.ints.unsigned;
                      default = 3;
                    };
                    monthly = mkOption {
                      type = types.ints.unsigned;
                      default = 3;
                    };
                    yearly = mkOption {
                      type = types.ints.unsigned;
                      default = 3;
                    };
                  };
                };

                config = {
                  passwordFile = mkDefault cfg.defaultPasswordFile;
                  environmentFile = mkDefault cfg.defaultEnvironmentFile;
                  repositoryFile = mkDefault cfg.defaultRepositoryFile;

                  pruneOpts = [
                    "--keep-daily ${toString config.snapshotsToKeep.daily}"
                    "--keep-weekly ${toString config.snapshotsToKeep.weekly}"
                    "--keep-monthly ${toString config.snapshotsToKeep.monthly}"
                    "--keep-yearly ${toString config.snapshotsToKeep.yearly}"
                  ];
                };
              }
            )
          );
        };
        stack-backup =
          let
            inherit (utils.systemdUtils.unitOptions) unitOption;
          in
          mkOption {
            type = types.attrsOf (
              types.submodule (
                { ... }:
                {
                  options = {
                    paths = mkOption {
                      type = types.listOf types.str;
                      default = [ ];
                      description = "Host paths of the volumes to back up";
                    };
                    timerConfig = mkOption {
                      type = types.nullOr (types.attrsOf unitOption);
                      default = {
                        OnCalendar = "03:00";
                        Persistent = true;
                      };
                      description = "Timer config to be passed directly to the restic timer";
                    };
                  };
                }
              )
            );
          };
      };

      config = {
        environment.systemPackages = mkIf cfg.enable [
          pkgs.restic
        ];
        services.restic.backups =
          let
            svcName = composeName: "docker-compose-${composeName}";
          in
          mapAttrs' (
            name: value:
            nameValuePair (name) ({
              initialize = true;
              paths = value.paths;
              timerConfig = value.timerConfig // {
                RandomizedDelaySec = 1800;
              };
              repositoryFile = cfg.defaultRepositoryFile;
              environmentFile = cfg.defaultEnvironmentFile;
              passwordFile = cfg.defaultPasswordFile;
              extraBackupArgs = [
                "--tag"
                name
              ];
              backupPrepareCommand = "systemctl stop ${svcName name}.service";
              backupCleanupCommand = "systemctl start ${svcName name}.service";
            })
          ) cfg.stack-backup;
      };
    };
}
