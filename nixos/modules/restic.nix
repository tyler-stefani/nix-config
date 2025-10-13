{ ... }:
{
  flake.nixosModules.restic =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    with lib;
    {
      options.services.restic = {
        enable = mkEnableOption "a scheduled backup service";
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
      };

      config = mkIf config.services.restic.enable {
        environment.systemPackages = [
          pkgs.restic
        ];
      };
    };
}
