{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [];

  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  systemd.tmpfiles.rules = [
    "d /home/test/dotfiles 0755 test users -"
  ];

  fileSystems."/home/test/dotfiles" = {
    device = "dotfiles";
    fsType = "vboxsf";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "dmode=0755"
      "fmode=0644"
      "noauto"
      "x-systemd.automount"
      "nofail"
    ];
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.virtualbox.guest.enable = true;
}
