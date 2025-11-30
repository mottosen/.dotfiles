#!/usr/bin/env bash

wallpaper=$1
echo "Wallpaper changed to: $wallpaper"
rm "$HOME/wallpaper"
ln -s "$wallpaper" "$HOME/wallpaper"

echo "Wallpaper was updated, running Matugen"
matugen image "$wallpaper"

# echo "Matugen colors updated, reloading waybar"
# sleep 1
# ~/.config/waybar/reload.sh
