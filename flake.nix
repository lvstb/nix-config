{
  description = "NixOS and Home Manager configuration";

  inputs = {
    # Main nixpkgs channel
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Secrets management with sops-nix
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Personal nvim config
    nvim-config = {
      url = "github:lvstb/nvim-config";
      flake = false;
    };

    # Secure Boot for NixOS
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager for user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Portable CI/CD
    dagger.url = "github:dagger/nix";

    # System-wide styles
    stylix.url = "github:danth/stylix";

    # VSCode extensions
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware support
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Framework laptop ectool
    fw-ectool = {
      url = "github:tlvince/ectool.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    allowUnfree = true;
    # Also add this to make it work with --impure flag
    accept-flake-config = true;
  };

  outputs = { self, nixpkgs, ... } @ inputs: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    # Create pkgs with unfree enabled
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # Simple overlays
    overlays = [
      (_: _: {fw-ectool = inputs.fw-ectool.packages.${system}.ectool;})
      (final: prev: {dagger = inputs.dagger.packages.${system}.dagger;})
    ];

    # Base user config modules
    homeModules = [
      ./home/apps.nix
      ./home/git.nix
      ./home/lazygit.nix
      ./home/terminal.nix
      ./home/vscode.nix
      ./home/firefox.nix
      ./home/thunderbird.nix
      ./home/nvim.nix
      ./home/gnome.nix
      ./home/development.nix
    ];

    # Base OS configs
    osModules = [
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.nixos-hardware.nixosModules.common-hidpi
      inputs.stylix.nixosModules.stylix
      inputs.sops-nix.nixosModules.sops
      ./system/boot.nix
      ./system/os.nix
      ./system/global.nix
      ./system/performance.nix
      ./system/security.nix
      ./system/monitoring.nix
      ./home/stylix.nix
      { nixpkgs.overlays = overlays; }
    ];
  in {
    # Home Manager configurations
    homeConfigurations = {
      lars = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = homeModules ++ [./users/lvstb.nix] ++ [{
          nixpkgs.config.allowUnfree = true;
        }];
        extraSpecialArgs = {
          inherit inputs;
          vscode-extensions = inputs.nix-vscode-extensions.extensions.${system}.vscode-marketplace;
        };
      };
      
      beelink = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = homeModules ++ [./users/beelink.nix] ++ [{
          nixpkgs.config.allowUnfree = true;
        }];
        extraSpecialArgs = {
          inherit inputs;
          vscode-extensions = inputs.nix-vscode-extensions.extensions.${system}.vscode-marketplace;
        };
      };
    };

    # NixOS configurations
    nixosConfigurations = {
      framework = lib.nixosSystem {
        inherit system;
        modules = osModules ++ [
          inputs.nixos-hardware.nixosModules.framework-13-7040-amd
          ./hosts/framework/configuration.nix
          { nixpkgs.config.allowUnfree = true; }
        ];
        specialArgs = { inherit inputs; };
      };
      
      beelink = lib.nixosSystem {
        inherit system;
        modules = osModules ++ [
          ./hosts/beelink/configuration.nix
          { nixpkgs.config.allowUnfree = true; }
        ];
        specialArgs = { inherit inputs; };
      };
    };

    # Formatter
    formatter.${system} = pkgs.alejandra;

    # Custom packages
    packages.${system} = {
      dagger = inputs.dagger.packages.${system}.dagger;
    };
  };
}
