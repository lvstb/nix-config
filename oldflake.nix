{
  description = "My nixos flake";

  inputs = {
    nixos-pkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Provides module support for specific vendor hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        
    # Secure Boot for NixOS
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixos-pkgs";
    };
        
    # Stylix is a NixOS module for managing system-wide styles
    stylix.url = "github:danth/stylix";
        
    # User profile manager based on Nix
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # fw ectool as configured for FW13 7040 AMD (until patch is upstreamed)
    fw-ectool = {
      url = "github:tlvince/ectool.nix";
      inputs.nixpkgs.follows = "nixos-pkgs";
    };
        
    zen-browser.url = "github:MarceColl/zen-browser-flake";
        
    #Ghostty is a new terminal emulator
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs = {
    nixpkgs,
    ...
  } @ inputs: let
    username = "lvstb";
    userfullname = "Lars Van Steenbergen";
    useremail = "lars@wingu.dev";
    system = "x86_64-linux"; # aarch64-darwin or x86_64-darwin
    osOverlays = [
    (_: _: { fw-ectool = inputs.fw-ectool.packages.${system}.ectool; })
    ];

    # Base OS configs, adapts to system configs
    osModules = [
        inputs.lanzaboote.nixosModules.lanzaboote
        ./system/boot.nix
    ];
            
    # Function to build a home configuration from user modules
    homeUser = (userModules: inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # userModules overwrites, so is appended
        modules = homeModules ++ guiModules ++ userModules;
    });

    # Function to build a nixos configuration from system modules
    nixosSystem = (systemModules: nixpkgs.lib.nixosSystem {
        inherit system;
        # osModules depends on some values from systemModules, so is appended
        modules = systemModules ++ osModules;
    });       
            
    specialArgs =
      inputs
      // {
        inherit username userfullname useremail;
      };
  in {
      homeConfigurations = {
        lvstb = homeUser [ ./users/lvstb.nix ];

      };
    nixosConfigurations = {
        framework = nixosSystem [
          inputs.nixos-hardware.nixosModules.framework-13-7040-amd
          inputs.stylix.nixosModules.stylix
          ./hosts/framework/configuration.nix
          {
          nixpkgs.overlays = osOverlays;
          }
        ];
    };
  };
    # nixosConfigurations.framework = nixpkgs.lib.nixosSystem {
    #   specialArgs = {inherit inputs username userfullname useremail system;}; system = "x86_64-linux"; # aarch64-darwin or x86_64-darwin
    #   modules = [
    #     ./hosts/framework/configuration.nix
    #     inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    #     inputs.stylix.nixosModules.stylix
    #   ];
    # };
    # nix code formatter
    # formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  # };
}
