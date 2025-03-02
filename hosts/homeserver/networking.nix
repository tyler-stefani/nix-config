{ ... }:
{
  networking = {
    hostName = "homeserver";

    # Enable networking
    networkmanager.enable = true;

    oci.networks = {
      bridge = {
        enable = true;
        name = "private";
      };
      ipvlan = {
        enable = true;
      };
    };
  };
}
