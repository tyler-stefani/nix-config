lib: dir:
let
  walk =
    dir:
    let
      entries = builtins.readDir dir;
    in
    builtins.listToAttrs (
      builtins.concatMap (
        name:
        let
          currPath = dir + /${name};
          entryType = entries.${name};
        in
        with lib;
        if entryType == "directory" then
          if hasAttr "default.nix" (builtins.readDir currPath) then
            [ (nameValuePair name currPath) ]
          else
            let
              nested = walk currPath;
            in
            if nested == { } then [ ] else [ (nameValuePair name nested) ]
        else
          [ ]
      ) (builtins.attrNames entries)
    );
in
walk dir
