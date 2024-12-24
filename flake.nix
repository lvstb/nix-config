{
  description = "My nixos flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    stylix.url = "github:danth/stylix";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    username = "lvstb";
    userfullname = "Lars Van Steenbergen";
    useremail = "lars@wingu.dev";
    system = "x86_64-linux"; # aarch64-darwin or x86_64-darwin

    specialArgs =
      inputs
      // {
        inherit username userfullname useremail;
      };
  in {
    nixosConfigurations.framework = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs username userfullname useremail system;};
      system = system;
      modules = [
        ./hosts/framework/configuration.nix
        inputs.nixos-hardware.nixosModules.framework-13-7040-amd
        inputs.stylix.nixosModules.stylix
      ];
    };
    # nix code formatter
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
