{ lib, config, ... }:

with lib;

{
  options.hostConfig = {
    hostName = mkOption {
      type = types.str;
    };
    directories = {
      personalData = mkOption {
        type = types.path;
      };
      appData = mkOption {
        type = types.path;
      };
      secrets = mkOption {
        type = types.path;
      };
    };
  };

  config = {
    networking = {
      hostName = config.hostConfig.hostName;
    };
  };
}
