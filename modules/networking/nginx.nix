{ props, ... }:

{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  virtualisation.oci-containers.containers = {
    proxy = {
      image = "docker.io/jc21/nginx-proxy-manager:latest";
      ports = [
        "80:80"
        "443:443"
      ];
      volumes = [
        "${props.homeServer.directory}/nginx/data:/data"
        "${props.homeServer.directory}/nginx/letsencrypt:/etc/letsencrypt"
      ];
      networks = [
        props.network.name
      ];
    };
  };
}
