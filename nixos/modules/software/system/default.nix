{ config, lib, pkgs, ... }:

let
  user = config.userSettings.username;
in
{
  imports = [
    ../../../profiles
    ./shell
  ];

  # General
  system.stateVersion = "25.05"; # Do not change
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  # Location and Network
  time.timeZone = config.systemSettings.timezone;
  i18n.defaultLocale = config.systemSettings.locale;
  networking = {
    hostName = config.systemSettings.hostname;
    networkmanager.enable = true;
  };

  # System wide packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  # Baseline terminal
  users.defaultUserShell = pkgs.bash;
  environment = {
    shells = with pkgs; [ bash zsh ];
    sessionVariables = {
      EDITOR = config.userSettings.editor;
      VISUAL = config.userSettings.editor;
    };
  };

  # TODOTODO: consider
  services.xserver = {
    enable = true;
    windowManager.qtile.enable = true;
  };

  users.users."${user}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "vboxsf" ];
  };
}
