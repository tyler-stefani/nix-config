set -l hosts \
    "bubblegum=bubblegum" \
    "coconut=coconut" \
    "cookies-and-cream=23.95.220.100"

set FLAKE_HOST $argv[1]
set rest_args $argv[2..]

if test -z "$FLAKE_HOST"
    echo "Usage: nixdeploy <hostname> [nh args...]"
    echo ""
    echo "Available hosts:"
    for entry in $hosts
        set parts (string split "=" $entry)
        echo "  $parts[1]  ->  $parts[2]"
    end
    exit 1
end

set TARGET_IP ""
for entry in $hosts
    set parts (string split "=" $entry)
    if test "$parts[1]" = "$FLAKE_HOST"
        set TARGET_IP $parts[2]
        break
    end
end

if test -z "$TARGET_IP"
    echo "Error: unknown host '$FLAKE_HOST'"
    echo "Add it to the hosts list in this script."
    exit 1
end

nh os switch . -a \
    --target-host tyler@$TARGET_IP \
    -H $FLAKE_HOST \
    $rest_args
