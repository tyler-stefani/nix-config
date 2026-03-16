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
      };
      users.users.tyler = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK5w7m9bwtX1tMoxmOKfDRPUeN4scTtpnBTNHdkI8Wgt tyler"
        ];
      };
    };
}
