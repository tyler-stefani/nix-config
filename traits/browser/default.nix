{ ... }:
{
  lab.traits.has.browser.home =
    { ... }:
    {
      programs.firefox = {
        enable = true;
        profiles.default = {
          isDefault = true;
          search = {
            force = true;
            default = "ddg";
          };
          settings = {
            "sidebar.revamp" = true;
            "sidebar.verticalTabs" = true;
          };
        };
      };

      stylix.targets = {
        firefox = {
          enable = true;
          profileNames = [ "default" ];
        };
      };
    };
}
