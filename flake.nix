{
  description = "NixOS and Home Manager configuration";

  inputs = {
    # Main nixpkgs channels
    nixos-pkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Personal nvim config
    nvim-config = {
      url = "github:lvstb/nvim-config";
      flake = false; # Treat as source, not a flake
    };

    # Secure Boot for NixOS
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixos-pkgs";
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
      inputs.nixpkgs.follows = "nixos-pkgs";
    };
  };

  nixConfig = {
    allowUnfree = true;
    # Also add this to make it work with --impure flag
    accept-flake-config = true;
  };

  outputs = {
    self,
    nixpkgs,
    nixos-pkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    lib = nixos-pkgs.lib;

    # Create pkgs with unfree enabled
    pkgs = import nixpkgs {
      inherit system;
    };

    # OS overlays
    osOverlays = [
      (_: _: {fw-ectool = inputs.fw-ectool.packages.${system}.ectool;})
      (final: prev: {dagger = inputs.dagger.packages.${system}.dagger;})
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
      ./home/nvim.nix
    ];

    # GUI-specific modules
    guiModules = [
      ./home/gnome.nix
      # ./home/stylix.nix
    ];

    # Base OS configs
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

    # Function to build a home configuration
    homeUser = userModules:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules =
          homeModules
          ++ guiModules
          ++ userModules;
        extraSpecialArgs = {
          inherit inputs;
          # Pass VSCode extensions with proper unfree handling
          vscode-extensions = inputs.nix-vscode-extensions.extensions.${system};
        };
      };

    # Function to build a NixOS configuration
    nixosSystem = systemModules:
      lib.nixosSystem {
        inherit system;
        modules =
          systemModules
          ++ osModules;
        specialArgs = {
          inherit inputs;
        };
      };
  in {
    # Home Manager configurations
    homeConfigurations = {
      lars = homeUser [./users/lvstb.nix];
    };

    # NixOS configurations
    nixosConfigurations = {
      framework = nixosSystem [
        inputs.nixos-hardware.nixosModules.framework-13-7040-amd
        ./hosts/framework/configuration.nix
      ];
    };

    # Formatter
    formatter.${system} = pkgs.alejandra;
  };
}
