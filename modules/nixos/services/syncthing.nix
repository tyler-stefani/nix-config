{ lib, config, ... }:
with lib;

let
  cfg = config.services.syncthing;
in
{
  options.services.syncthing = {
    guiPort = mkOption {
      type = types.port;
      default = 8384;
    };
    openGuiPort = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the gui port in the firewall for access on a headless server";
    };
  };

  config = mkIf cfg.enable {
    services.syncthing.guiAddress =
      (if cfg.openGuiPort then "0.0.0.0" else "127.0.0.1") + ":${toString cfg.guiPort}";
    networking.firewall = mkIf cfg.openGuiPort {
      allowedTCPPorts = [ cfg.guiPort ];
    };
  };
}
