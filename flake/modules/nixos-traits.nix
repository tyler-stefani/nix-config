{
  inputs,
  lib,
  moduleLocation,
  ...
}:

{
  options = {
    flake = inputs.flake-parts.lib.mkSubmoduleOptions {
      nixosTraits = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.deferredModule;
        default = { };
        apply = lib.mapAttrs (
          k: v: {
            _file = "${toString moduleLocation}#nixosTraits.${k}";
            imports = [ v ];
          }
        );
        description = ''
          Nixos traits are specific reusable configuration modules that do not expose options. 
          Traits are meant to be imported directly into a nixosConfiguration.
        '';
      };
    };
  };
}
