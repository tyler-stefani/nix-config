{ ... }:
{
  flake.nixosModules.docker-stack =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    with lib;
    {
      options.virtualisation.docker-stack = mkOption {
        type = types.attrsOf (
          types.submodule (
            { name, ... }:
            {
              options = {
                serviceName = mkOption {
                  type = types.str;
                  description = "Name of the systemd service to manage the deployment of the docker stack";
                  default = "docker-stack-${name}";
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
        description = "Container stacks to be deployed to a docker swarm";
      };

      config =
        let
          cfg = config.virtualisation.docker-stack;
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
              description = "Docker stack deployer for ${name}";

              serviceConfig = {
                Type = "oneshot";
                Environment = mapAttrsToList (k: v: "${k}=${v}") value.env;
                EnvironmentFile = value.envPath;
                ExecStart = "${pkgs.docker}/bin/docker stack deploy -d=false -c ${composeFile} ${name}";
                ExecStop = "${pkgs.docker}/bin/docker stack rm ${name}";
                ProtectHome = "off";
                RemainAfterExit = true;
              };

              restartTriggers = [ composeFile ];
            })
          ) cfg;
        };
    };
}
