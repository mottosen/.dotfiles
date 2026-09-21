#!/usr/bin/env bash
set -euo pipefail

wallpaper="${1:-}"

if [[ -z "$wallpaper" ]]; then
    # Fall back to whatever waypaper currently has set.
    wallpaper=$(awk -F' = ' '/^wallpaper/ {print $2}' "$HOME/.config/waypaper/config.ini")
    wallpaper="${wallpaper/#\~/$HOME}"
fi

if [[ ! -f "$wallpaper" ]]; then
    echo "on_wallpaper_update: no such wallpaper: '$wallpaper'" >&2
    exit 1
fi

echo "Wallpaper changed to: $wallpaper"
ln -sfn "$wallpaper" "$HOME/wallpaper"

echo "Restarting hyprpaper so every monitor picks up the new wallpaper"
# hyprpaper resolves the `path = ~/wallpaper` line in hyprpaper.conf exactly once,
# when it parses its config, and 0.8.4 dropped every IPC command that could
# refresh that (reload/preload/unload all answer "invalid hyprpaper request").
# waypaper only pushes the new wallpaper to the monitors connected right now, so
# without this a monitor plugged in later gets painted from the stale config path
# -- whatever ~/wallpaper pointed at when hyprpaper started. A restart re-resolves
# it, and hyprpaper then handles hotplugs by itself with nothing left running.
pkill -x hyprpaper || true
setsid hyprpaper >/dev/null 2>&1 &

echo "Wallpaper was updated, running Matugen"
# --prefer is required: since matugen 4.x an image with several candidate
# source colors prompts for a pick, which hard-fails when run without a tty
# (i.e. from the waypaper post_command) and leaves the colors stale.
matugen --prefer saturation image "$wallpaper"

# echo "Matugen colors updated, reloading waybar"
# sleep 1
# ~/.config/waybar/reload.sh
