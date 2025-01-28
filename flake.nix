{
  inputs = {
    nixos-pkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Secure Boot for NixOS
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixos-pkgs";
    };
    
   #home-manager is  a module to manage your user config 
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stylix is a NixOS module for managing system-wide styles
    stylix.url = "github:danth/stylix";
        
    # VSCode extensions     
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };        
        
    # Provides module support for specific vendor hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    # nixos-hardware.url = "https://github.com/NixOS/nixos-hardware/archive/e7ac747157a3301034b0caea9eb45c7b071e52fd.zip";

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
        ./home/shell.nix
        ./home/firefox.nix
        ./home/tmux.nix
        ./home/thunderbird.nix
      ];

      # Additional user applications and configurations
      guiModules = [
        ./home/gnome.nix
        # ./home/stylix.nix
      ];


      # Base OS configs, adapts to system configs
      osModules = [
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.nixos-hardware.nixosModules.common-hidpi
        inputs.stylix.nixosModules.stylix
        ./system/boot.nix
        ./system/os.nix
        ./system/global.nix
        ./home/stylix.nix
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
        lars = homeUser [ ./users/lvstb.nix ];
      };
      nixosConfigurations = {
        framework = nixosSystem [
          inputs.nixos-hardware.nixosModules.framework-13-7040-amd
          ./hosts/framework/configuration.nix
        ];

      };
    };
}
