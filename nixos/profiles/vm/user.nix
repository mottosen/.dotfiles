{ config, ... }:

{
  imports = [
    ../../.definitions
    ../../modules/software/user
  ];

  userSettings = {
    defaultShell = "zsh";
    shellAliases = {
      foobar = "echo 'hi there'";
    };
  };
}
