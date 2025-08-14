{ config, ... }:

{
  imports = [
    ../../.definitions
    ../../modules/software/user
  ];

  userSettings = {
    username = "test";
    name = "test user";
    email = "test@vm.com";
    windowManager = "";
    browser = "";
    terminal = "";
    font = "";
    shell = "zsh";
    shellAliases = {
      la = "ls -al --color";
    };
  };
}
