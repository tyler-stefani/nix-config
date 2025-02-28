{
  pkgs,
  lib,
  config,
  ...
}:

let
  backend = "docker";
  containerBin = "${pkgs.${backend}}/bin/${backend}";
  proxy = config.containerNetworks.bridge;
  vlan = config.containerNetworks.ipvlan;
in
{
  options = {
    containerNetworks = {
      bridge = {
        enable = lib.mkEnableOption "a custom bridge network for containers";
        name = lib.mkOption {
          type = lib.types.str;
          default = "proxy";
        };
      };
      ipvlan = {
        enable = lib.mkEnableOption "an ipvlan network for containers";
        name = lib.mkOption {
          type = lib.types.str;
          default = "vlan";
        };
        subnet = lib.mkOption {
          type = lib.types.str;
          default = "192.168.0.0/24";
        };
        gateway = lib.mkOption {
          type = lib.types.str;
          default = "192.168.0.1";
        };
        parent = lib.mkOption {
          type = lib.types.str;
          default = "eno1";
        };
      };
    };
  };

  config = {
    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = backend;

    system.activationScripts.createProxyNetwork = lib.mkIf proxy.enable ''
      ${containerBin} network inspect ${proxy.name} >/dev/null 2>&1 || \
      ${containerBin} network create ${proxy.name}
    '';

    system.activationScripts.createVlanNetwork = lib.mkIf vlan.enable ''
      ${containerBin} network inspect ${vlan.name} >/dev/null 2>&1 || \
      ${containerBin} network create \
      -d ipvlan \
      --subnet ${vlan.subnet} \
      --gateway ${vlan.gateway} \
      -o parent=${vlan.parent} \
      ${vlan.name} 
    '';
  };
}
