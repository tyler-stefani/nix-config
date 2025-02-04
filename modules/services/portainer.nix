{ props, ... }:

{
  virtualisation.oci-containers = {
    containers = {
      containers = {
        image = "portainer/portainer-ce:latest";
        volumes = [
          "${props.homeServer.directory}/portainer/data:/data"
          "/var/run/docker.sock:/var/run/docker.sock"
        ];
        networks = [
          props.network.name
        ];
      };
    };
  };
}
