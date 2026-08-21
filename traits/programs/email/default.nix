{ ... }:
{
  lab.traits.programs.email.home =
    { ... }:
    {
      programs.thunderbird = {
        enable = true;

        profiles.default = {
          isDefault = true;
        };
      };
    };
}
