#!/usr/bin/env bash
# Send a notification that blinks.
#
# mako has no animation support, so the effect is faked: the same notification
# id is replaced over and over, alternating between the [category=uair] and
# [category=uair-blink] styles defined in ~/.config/mako/config.
#
# Usage: blink-notify.sh SUMMARY [BODY] [BLINKS]

summary=${1:?usage: blink-notify.sh SUMMARY [BODY] [BLINKS]}
body=${2:-}
blinks=${3:-8}
interval=0.35

# The id has to come from the server, so post once and reuse what we get back;
# every pulse then replaces that popup instead of stacking a new one.
id=$(notify-send -p -c uair "$summary" "$body")

# Redraw the popup in the given style. mako echoes back the same id as long as
# the notification is alive, and a fresh one once it has been dismissed or has
# timed out -- that mismatch is how we notice the user clicked it away. Without
# this the loop would resurrect a new popup on every remaining pulse.
pulse() {
	local new_id
	new_id=$(notify-send -p -r "$id" -c "$1" "$summary" "$body")
	if [[ $new_id != "$id" ]]; then
		makoctl dismiss -n "$new_id"
		exit 0
	fi
}

for ((i = 0; i < blinks; i++)); do
	sleep "$interval"
	pulse uair-blink
	sleep "$interval"
	pulse uair
done
