{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (config.userSettings.windowManager == "hypr") {
    programs.foot.enable = true;
    programs.waybar.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        # VM-friendly env
        env = [
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "WLR_NO_HARDWARE_CURSORS,1"
          "WLR_RENDERER_ALLOW_SOFTWARE,1"   # let it fall back to llvmpipe if needed
        ];

        # Launch something so the screen isn't empty
        exec-once = [
          "waybar"
          "hyprpaper"                        # or: "swaybg -i /path/to/wallpaper"
          "foot --server &"                  # enables fast footclient launches
        ];

        # Keybinds: SUPER+Enter opens a terminal that actually exists
        bind = [
          "SUPER,RETURN,exec,footclient"
          "SUPER,Q,killactive,"
          "SUPER,E,exec,footclient -e htop"
          "SUPER,R,exec,hyprctl dispatch resolution 1920 1080"
        ];
      };
    };

    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [ "/run/current-system/sw/share/backgrounds/nixos/nix-wallpaper-simple-blue.png" ];
        wallpaper = [ ",/run/current-system/sw/share/backgrounds/nixos/nix-wallpaper-simple-blue.png" ];
      };
    };

    # home.file."hypr" = {
    #   target = ".config/hypr/";
    #   source = config.userSettings.configFiles +
    #     "/hypr/";
    #   recursive = true;
    #   force = true;
    # };
  };
}
