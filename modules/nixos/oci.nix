{ ... }:
{
  flake.nixosModules.oci =
    {
      pkgs,
      lib,
      config,
      ...
    }:

    let
      backend = config.virtualisation.oci-containers.backend;
      containerBin = "${pkgs.${backend}}/bin/${backend}";
      proxy = config.networking.oci.networks.bridge;
      vlan = config.networking.oci.networks.ipvlan;
    in
    {
      options.networking.oci.networks = {
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

      config.system.activationScripts = {
        createProxyNetwork = lib.mkIf proxy.enable ''
          ${containerBin} network inspect ${proxy.name} >/dev/null 2>&1 || \
          ${containerBin} network create ${proxy.name}
        '';

        createVlanNetwork = lib.mkIf vlan.enable ''
          ${containerBin} network inspect ${vlan.name} >/dev/null 2>&1 || \
          ${containerBin} network create \
          -d ipvlan \
          --subnet ${vlan.subnet} \
          --gateway ${vlan.gateway} \
          -o parent=${vlan.parent} \
          ${vlan.name} 
        '';
      };
    };
}
