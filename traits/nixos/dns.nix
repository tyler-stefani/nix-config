{ self, ... }:
{
  virtualisation.docker-compose.dns = {
    dir = self + /stacks/dns;
    env = {
      TIMEZONE = "America/Chicago";
      PASSWORD = builtins.readFile "${self}/secrets/dns/password";
      TS_AUTHKEY = builtins.readFile "${self}/secrets/dns/authkey";
    };
  };
}
