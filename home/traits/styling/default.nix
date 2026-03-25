{ ... }:
{
  flake.homeTraits.styling =
    { pkgs, config, ... }:
    {
      stylix = {
        enable = true;
        autoEnable = false;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
      };
    };
}
