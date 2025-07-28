{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
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
        };
      }
    );
    default = { };
    description = "Container stacks managed by docker-compose";
  };

  config.systemd.services = mapAttrs' (
    name: value:
    let
      envLines = mapAttrsToList (k: v: "${k}=${v}") value.env;
    in
    nameValuePair ("docker-compose-${name}") ({
      wantedBy = [ "multi-user.target" ];
      requires = [ "docker.service" ];
      after = [ "docker.service" ];
      description = "Docker Compose manager for ${name}";

      serviceConfig = {
        WorkingDirectory = value.dir;
        Environment = envLines;
        ExecStart = "${pkgs.docker-compose}/bin/docker-compose up";
        ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
        ProtectHome = "off";
        Restart = "always";
      };
    })
  ) config.virtualisation.docker-compose;
}
