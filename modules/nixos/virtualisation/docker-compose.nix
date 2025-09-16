{
  flakePath,
  config,
  lib,
  pkgs,
  utils,
  ...
}:
with lib;
let
  inherit (utils.systemdUtils.unitOptions) unitOption;
in
{
  options.virtualisation.docker-compose = mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          dir = mkOption {
            type = types.path;
            description = "Path to directory containing a docker-compose.yaml";
          };
          env = mkOption {
            type = types.attrsOf types.str;
            default = { };
            description = "Environment variables to write to an .env file";
          };
          backup = {
            enable = mkEnableOption "backing up of volumes for these containers";
            paths = mkOption {
              type = types.listOf types.str;
              default = [ ];
              description = "Host paths of the volumes to back up";
            };
            timerConfig = mkOption {
              type = types.nullOr (types.attrsOf unitOption);
              default = {
                OnCalendar = "01:00";
                Persistent = true;
              };
              description = "Timer config to be passed directly to the restic timer";
            };
          };
        };
      }
    );
    default = { };
    description = "Container stacks managed by docker-compose";
  };

  config =
    let
      cfg = config.virtualisation.docker-compose;
      svcName = composeName: "docker-compose-${composeName}";
    in
    {
      systemd.services = mapAttrs' (
        name: value:
        let
          composeFile = pkgs.writeTextFile {
            name = "${svcName name}.yaml";
            text = builtins.readFile "${value.dir}/docker-compose.yaml";
          };
        in
        nameValuePair (svcName name) ({
          wantedBy = [ "multi-user.target" ];
          requires = [ "docker.service" ];
          after = [ "docker.service" ];
          description = "Docker Compose manager for ${name}";

          serviceConfig = {
            Environment = mapAttrsToList (k: v: "${k}=${v}") value.env;
            ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f ${composeFile} -p ${name} up";
            ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f ${composeFile} -p ${name} down";
            ProtectHome = "off";
            Restart = "always";
          };

          restartTriggers = [ composeFile ];
        })
      ) cfg;

      services.restic = {
        enable = true;
        backups = mapAttrs' (
          name: value:
          nameValuePair (name) (
            mkIf value.backup.enable {
              initialize = true;
              paths = value.backup.paths;
              timerConfig = value.backup.timerConfig // {
                RandomizedDelaySec = 1800;
              };
              repositoryFile = builtins.toString (flakePath + /secrets/backup/repository);
              environmentFile = builtins.toString (flakePath + /secrets/backup/environment);
              passwordFile = builtins.toString (flakePath + /secrets/backup/password);
              extraBackupArgs = [
                "--tag"
                name
              ];
              backupPrepareCommand = "systemctl stop ${svcName name}.service";
              backupCleanupCommand = "systemctl start ${svcName name}.service";
            }
          )
        ) cfg;
      };
    };
}
