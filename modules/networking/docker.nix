{ pkgs, props, ... }:

let
  backend = "docker";
  containerBin = "${pkgs.${backend}}/bin/${backend}";
in
{
  virtualisation.docker.enable = true;

  virtualisation.oci-containers.backend = backend;

  system.activationScripts.createDockerNetwork = ''
    ${containerBin} network inspect ${props.network.name} >/dev/null 2>&1 || ${containerBin} network create ${props.network.name}
  '';
}
