{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lanzaboote.url = "github:nix-community/lanzaboote";
    stylix.url = "github:danth/stylix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stylix is a NixOS module for managing system-wide styles
    stylix.url = "github:danth/stylix";
        
    zen-browser.url = "github:MarceColl/zen-browser-flake";
        
    #Ghostty is a new terminal emulator
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
        
    # Provides module support for specific vendor hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # fw ectool as configured for FW13 7040 AMD (until patch is upstreamed)
    fw-ectool = {
      url = "github:tlvince/ectool.nix";
      inputs.nixpkgs.follows = "nixos-pkgs";
    };
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = inputs.nixos-pkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      osOverlays = [
        (_: _: { fw-ectool = inputs.fw-ectool.packages.${system}.ectool; })
      ];

      # Base user config modules
      homeModules = [
        ./home/applications.nix
        ./home/git.nix
        ./home/lazygit.nix
        ./home/starship.nix
        ./home/vscode.nix
      ];

      # Additional user applications and configurations
      guiModules = [
        ./home/gnome.nix
        ./home/stylix.nix
      ];


      # Base OS configs, adapts to system configs
      osModules = [
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.nixos-hardware.nixosModules.common-hidpi
        ./system/boot.nix
        ./system/os.nix
        ./system/global.nix
        {
          nixpkgs.overlays = osOverlays;
        }
      ];

      # Function to build a home configuration from user modules
      homeUser = (userModules: inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # userModules overwrites, so is appended
        modules = homeModules ++ guiModules ++ userModules;
      });

      # Function to build a nixos configuration from system modules
      nixosSystem = (systemModules: lib.nixosSystem {
        inherit system;
        # osModules depends on some values from systemModules, so is appended
        modules = systemModules ++ osModules;
      });


    in {
      homeConfigurations = {
        lvstb = homeUser [ ./users/lvstb.nix ];
      };
      nixosConfigurations = {
        framework = nixosSystem [
          inputs.nixos-hardware.nixosModules.framework-13-7040-amd
          ./hosts/framework/configuration.nix
        ];

      };
    };
}
