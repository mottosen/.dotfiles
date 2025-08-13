{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-host";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Copenhagen";

  services.xserver = {
    enable = true;
    windowManager.qtile.enable = true;
  };

  users.users.test = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "vboxsf" ];
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  system.stateVersion = "25.05"; # Do not change

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  virtualisation.virtualbox.guest.enable = true;

}
