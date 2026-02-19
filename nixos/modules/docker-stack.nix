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
          types.submodule {
            options = {
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
        );
        default = { };
        description = "Container stacks to be deployed to a docker swarm";
      };

      config =
        let
          cfg = config.virtualisation.docker-stack;
          svcName = composeName: "docker-stack-${composeName}";
        in
        {
          systemd.services = mapAttrs' (
            name: value:
            let
              composeFile = pkgs.writeTextFile {
                name = "${svcName name}.yaml";
                text = builtins.readFile value.file;
              };
            in
            nameValuePair (svcName name) ({
              wantedBy = [ "multi-user.target" ];
              requires = [ "docker.service" ];
              after = [ "docker.service" ];
              description = "Docker stack deployer for ${name}";

              serviceConfig = {
                Environment = mapAttrsToList (k: v: "${k}=${v}") value.env;
                EnvironmentFile = value.envPath;
                ExecStart = "${pkgs.docker}/bin/docker stack deploy -c ${composeFile} ${name}";
                ExecStop = "${pkgs.docker}/bin/docker stack remove -c ${composeFile} ${name}";
                ProtectHome = "off";
                Restart = "always";
              };

              restartTriggers = [ composeFile ];
            })
          ) cfg;
        };
    };
}
