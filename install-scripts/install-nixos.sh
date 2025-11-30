# save dotfiles dir
cd ..
DOTFILES_DIR=$(pwd)

# clear existing configs
cd ~
rm -rf .config/*

# symlink dotfiles to configs
cd $DOTFILES_DIR
stow -t ~ .

# ensure matugen colors are present
./.config/hypr/scripts/on_wallpaper_update.sh wallpaper.jpg

