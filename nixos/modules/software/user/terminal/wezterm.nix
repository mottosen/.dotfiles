{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (config.userSettings.terminal == "wezterm") {
    programs.wezterm = {
      enable = true;
      extraConfig = ''
        local wezterm = require 'wezterm'
        return {
          font = wezterm.font_with_fallback({
            "FiraCode Nerd Font Mono",
            "MesloLGS Nerd Font",
            "Noto Color Emoji",
          }),
          font_size = 12.0,
          color_scheme = "Builtin Solarized Dark",
          window_padding = { left = 6, right = 6, top = 6, bottom = 6 },
          window_decorations = "RESIZE",
          -- You're in a VirtualBox guest; Wayland is rare there. Keep this off unless you know you need it:
          enable_wayland = false,
          -- WezTerm uses your login shell by default; no need to set default_prog if your login shell is zsh.
        }
      '';
    };
  };
}
