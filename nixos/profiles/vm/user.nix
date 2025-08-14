{ config, ... }:

{
  imports = [
    ../../.definitions
    ../../modules/software/user
  ];

  userSettings = {
    defaultShell = "zsh";
    shellAliases = {
      la = "ls -al --color";
    };
  };
}
