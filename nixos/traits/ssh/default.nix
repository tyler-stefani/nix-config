{ ... }:
{
  flake.nixosTraits.is.ssh-server =
    { ... }:
    {
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "prohibit-password";
          PasswordAuthentication = false;
        };
        hostKeys = [
          {
            path = "/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];
      };
    };
}
