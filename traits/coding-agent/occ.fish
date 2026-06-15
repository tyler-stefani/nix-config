set -l workspace_dir "$PWD"

set -l i 1
while test $i -le (count $argv)
    switch $argv[$i]
        case --dir -d
            set i (math $i + 1)
            if test $i -le (count $argv)
                set workspace_dir $argv[$i]
            else
                echo "Error: $argv[(math $i - 1)] requires a value"
                exit 1
            end
        case '*'
            break
    end
    set i (math $i + 1)
end

set -l workspace_dir (cd "$workspace_dir" && pwd -P)

set -l runtime_dir (set -q XDG_RUNTIME_DIR && echo $XDG_RUNTIME_DIR; or echo $TMPDIR; or echo /tmp)
set -l config_dir (mktemp -d "$runtime_dir/opencode-config-XXXX")
cp -rL ~/.config/opencode/ "$config_dir/"
trap "rm -rf '$config_dir'" EXIT

podman run --rm -it \
    --cap-drop=ALL \
    # --user 1000 \
    --security-opt=no-new-privileges \
    --entrypoint opencode \
    --workdir /code \
    --volume "$workspace_dir:/code:Z" \
    --volume "$config_dir:/home/opencode/.config" \
    --env OPENCODE_CONFIG=/home/opencode/.config/opencode/config.json \
    --env XDG_CONFIG_HOME=/home/opencode/.config \
    ghcr.io/anomalyco/opencode:1.17.7
