#!/usr/bin/env bash
#
# Bind workspaces 6-10 to the external monitors of the current location.
#
#   external.sh get            print the current location label, for waybar
#   external.sh auto           adopt whichever external monitors are connected
#   external.sh DP-2           bind both vars to one output
#   external.sh DP-2 DP-4      bind 7-10 to DP-2 and 6 to DP-4
#
# The choice is stored in setups/external.conf as $external_1 and $external_2,
# which hyprland.conf sources and the workspace rules refer to. Only diku has a
# second external (the portrait P27q-20); everywhere else both vars name the
# same output, so workspace 6 just lands with the rest of 7-10.

set -u

conf="$HOME/.config/hypr/setups/external.conf"
laptop="eDP-1"

label() {
    case "$1 $2" in
        "DP-2 DP-4") echo "diku" ;;
        "DP-2 DP-2") echo "home" ;;
        "DP-5 DP-5") echo "samsung" ;;
        " ")         echo "none" ;;
        *)           [ "$1" = "$2" ] && echo "$1" || echo "$1+$2" ;;
    esac
}

# name and transform of every connected output, one per line. The transform is
# what tells us the orientation: hyprctl reports the mode, which stays landscape
# (2560x1440) on a monitor that is rotated into portrait by a transform.
monitors() {
    hyprctl monitors |
        awk '/^Monitor /            { name = $2 }
             /^[ \t]*transform: /   { print name, $2 }'
}

case "${1:-get}" in
    get)
        label "$(sed -n 's/^\$external_1 = //p' "$conf" | tail -1)" \
              "$(sed -n 's/^\$external_2 = //p' "$conf" | tail -1)"
        exit 0
        ;;
    auto)
        # The portrait output, if there is one, is the second external - that is
        # what distinguishes diku's pair from a single monitor anywhere else.
        landscape=""
        portrait=""
        while read -r name transform; do
            [ "$name" = "$laptop" ] && continue
            # odd transforms are the 90/270 degree ones, i.e. portrait
            if [ $((transform % 2)) -eq 1 ]; then
                [ -n "$portrait" ] || portrait=$name
            else
                [ -n "$landscape" ] || landscape=$name
            fi
        done <<EOF
$(monitors)
EOF
        primary=${landscape:-$portrait}
        secondary=${portrait:-$primary}
        ;;
    *)
        primary=$1
        secondary=${2:-$1}
        ;;
esac

[ -n "$primary" ] || exit 0

{
    printf '$external_1 = %s\n' "$primary"
    printf '$external_2 = %s\n' "$secondary"
} > "$conf"
hyprctl reload > /dev/null

# A reload only re-reads the rules, it does not relocate workspaces that are
# already open - only a monitor connect does that. So move them by hand,
# counting down so each monitor ends up showing the lowest of the ones it got.
active=$(hyprctl activeworkspace | sed -n 's/^workspace ID \([0-9]*\).*/\1/p')
hyprctl dispatch moveworkspacetomonitor 6 "$secondary" > /dev/null 2>&1
for ws in 10 9 8 7; do
    hyprctl dispatch moveworkspacetomonitor "$ws" "$primary" > /dev/null 2>&1
done
[ -n "$active" ] && hyprctl dispatch workspace "$active" > /dev/null

pkill -RTMIN+8 waybar
