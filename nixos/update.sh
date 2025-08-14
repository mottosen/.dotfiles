#!bin/bash

nix flake update
sudo nixos-rebuild switch --flake .#system
home-manager switch --flake .#user
