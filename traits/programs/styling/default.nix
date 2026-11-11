{ ... }:
{
  lab.traits.programs.styling = {
    home =
      { pkgs, config, ... }:
      {
        stylix = {
          enable = true;
          autoEnable = false;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
        };
      };
    nixos =
      { pkgs, config, ... }:
      {
        stylix = {
          enable = true;
          autoEnable = false;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
        };
      };
  };
}
