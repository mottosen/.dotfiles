{
  description = "Nix flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: 
    let
      profile = "vm";
      system = "x86_64-linux";

      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
    nixosConfigurations = {
      system = lib.nixosSystem {
        inherit system;
        modules = [
          (./profiles + ("/" + profile) + "/system.nix")
        ];
      };
    };
    homeConfigurations = {
      user = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (./profiles + ("/" + profile) + "/user.nix")
        ];
      };
    };
  };
}
