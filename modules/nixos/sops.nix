{ ... }:
{
  flake.nixosModules.sops =
    { lib, config, ... }:
    with lib;
    {
      options.sops.envs = mkOption {
        type = types.attrsOf (
          types.submodule (
            { name, config, ... }:
            {
              options = {
                sopsFile = mkOption {
                  type = types.path;
                  description = "The path to the sops encrypted dotenv file";
                };
                serviceName = mkOption {
                  type = types.str;
                  description = "The name of the service which consumes the decrypted dotenv file";
                  default = name;
                };
                path = mkOption {
                  type = types.str;
                  description = "The absolute path for decrypted dotenv file";
                  default = "/run/secrets/${config.serviceName}/.env";
                  readOnly = true;
                };
              };
            }
          )
        );
        default = { };
        description = "Environment (dotenv) files which are encrypted with sops at rest and decrypted into the /run directory on system build";
      };

      config.sops.secrets = mapAttrs' (
        key: value:
        nameValuePair "${value.serviceName}/.env" {
          format = "dotenv";
          sopsFile = value.sopsFile;
          key = "";
        }
      ) config.sops.envs;
    };
}
