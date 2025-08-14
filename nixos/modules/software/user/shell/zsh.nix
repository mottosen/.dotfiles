{ config, config-files, pkgs, lib, ... }:

{
  config = lib.mkIf (config.userSettings.shell == "zsh") {
    home.packages = [
      pkgs.oh-my-posh
    ];

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history = {
        size = 10000;
        save = 5000;
      };
      shellAliases = config.userSettings.shellAliases;
    };

    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      settings = builtins.fromTOML (builtins.unsafeDiscardStringContext (builtins.readFile "${config-files}/oh-my-posh/config.toml"));
    };
  };
}
