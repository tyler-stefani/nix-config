{
  inputs,
  lib,
  moduleLocation,
  ...
}:

{
  options = {
    flake = inputs.flake-parts.lib.mkSubmoduleOptions {
      homeTraits = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.deferredModule;
        default = { };
        apply = lib.mapAttrs (
          k: v: {
            _file = "${toString moduleLocation}#homeTraits.${k}";
            imports = [ v ];
          }
        );
        description = ''
          Home traits are specific reusable configuration modules that do not expose options. 
          Traits are meant to be imported directly into a homeConfiguration.
        '';
      };
    };
  };
}
