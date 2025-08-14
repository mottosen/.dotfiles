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

      initExtra = ''
        eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh \
          --config ${config.xdg.configHome}/oh-my-posh/config.yaml)"
      '';
    };

    xdg.configFile."oh-my-posh/config.yaml".source = config-files + /oh-my-posh/config.yaml;
  };
}
