{ pkgs, props, ... }:

let
  backend = "docker";
  containerBin = "${pkgs.${backend}}/bin/${backend}";
  proxy = props.networks.proxy;
  vlan = props.networks.vlan;
in
{
  virtualisation.docker.enable = true;

  virtualisation.oci-containers.backend = backend;

  system.activationScripts.createProxyNetwork = ''
    ${containerBin} network inspect ${proxy.name} >/dev/null 2>&1 || \
    ${containerBin} network create ${proxy.name}
  '';

  system.activationScripts.createVlanNetwork = ''
    ${containerBin} network inspect ${vlan.name} >/dev/null 2>&1 || \
    ${containerBin} network create \
    -d ipvlan \
    --subnet ${vlan.subnet} \
    --gateway ${vlan.gateway} \
    -o parent=${vlan.parent} \
    ${vlan.name} 
  '';
}
