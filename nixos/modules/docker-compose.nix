{ ... }:
{
  flake.nixosModules.docker-compose =
    {
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
          types.submodule (
            { name, ... }:
            {
              options = {
                serviceName = mkOption {
                  type = types.str;
                  description = "Name of the systemd service to manage the docker compose stack";
                  default = "docker-compose-${name}";
                };
                file = mkOption {
                  type = types.path;
                  description = "Path to the docker-compose yaml file";
                };
                env = mkOption {
                  type = types.attrsOf types.str;
                  default = { };
                  description = "Environment variables to write to an .env file";
                };
                envPath = mkOption {
                  type = types.str;
                  default = "";
                  description = "Path to environment files";
                };
              };
            }
          )
        );
        default = { };
        description = "Container stacks managed by docker-compose";
      };

      config =
        let
          cfg = config.virtualisation.docker-compose;
        in
        {
          systemd.services = mapAttrs' (
            name: value:
            let
              composeFile = pkgs.writeTextFile {
                name = "${value.serviceName}.yaml";
                text = builtins.readFile value.file;
              };
            in
            nameValuePair (value.serviceName) ({
              wantedBy = [ "multi-user.target" ];
              requires = [ "docker.service" ];
              after = [ "docker.service" ];
              description = "Docker Compose manager for ${name}";

              serviceConfig = {
                Environment = mapAttrsToList (k: v: "${k}=${v}") value.env;
                EnvironmentFile = value.envPath;
                ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f ${composeFile} -p ${name} up";
                ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f ${composeFile} -p ${name} down";
                ProtectHome = "off";
                Restart = "always";
              };

              restartTriggers = [ composeFile ];
            })
          ) cfg;
        };
    };
}
