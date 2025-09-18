{ lib, config, ... }:

with lib;

{
  options.host = {
    name = mkOption {
      type = types.str;
    };
    mounts = {
      data = mkOption {
        type = types.str;
      };
      config = mkOption {
        type = types.str;
      };
      media = mkOption {
        type = types.str;
      };
    };
  };

  config = {
    networking = {
      hostName = config.host.name;
    };
  };
}
