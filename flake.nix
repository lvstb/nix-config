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
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager for user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Portable CI/CD
    dagger.url = "github:dagger/nix";

    # AWS SSO CLI
    saws.url = "github:lvstb/saws";

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

    # Walker application launcher
    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Elephant backend for walker
    elephant = {
      url = "github:abenz1267/elephant";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    # Astal libraries (underlying framework for AGS v2)
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # AGS v2 scaffolding CLI + home-manager module
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.astal.follows = "astal";
    };
  };

  nixConfig = {
    # Also add this to make it work with --impure flag
    accept-flake-config = true;
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    # Simple overlays
    overlays = [
      (_: _: {fw-ectool = inputs.fw-ectool.packages.${system}.ectool;})
      (final: prev: {dagger = inputs.dagger.packages.${system}.dagger;})
      (final: prev: {saws = inputs.saws.packages.${system}.default;})
      (final: prev: import ./pkgs prev)
      (final: prev: {
        vscode-marketplace = inputs.nix-vscode-extensions.extensions.${system}.vscode-marketplace;
        vscode-marketplace-release = inputs.nix-vscode-extensions.extensions.${system}.vscode-marketplace-release;
      })
      inputs.nur.overlays.default
    ];

    # Create pkgs with unfree enabled and overlays applied
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = overlays;
    };

    # Shared home modules across all desktop environments
    baseHomeModules = [
      ./home/apps.nix
      ./home/git.nix
      ./home/lazygit.nix
      ./home/terminal.nix
      ./home/vscode.nix
      ./home/firefox.nix
      ./home/thunderbird.nix
      ./home/nvim.nix
      ./home/development.nix
      ./home/opencode.nix
      ./home/stylix.nix
      ./home/ghostty.nix
      ./home/claude.nix
    ];

    # GNOME desktop environment modules
    gnomeModules =
      baseHomeModules
      ++ [
        ./home/gnome/gnome.nix
      ];

    # Hyprland desktop environment modules
    hyprModules =
      [
        ./home/hyprland/hyprland-minimal.nix
      ]
      ++ baseHomeModules
      ++ [
        ./home/keyring.nix
      ];
    # Base OS configs
    osModules = [
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.nixos-hardware.nixosModules.common-hidpi
      inputs.stylix.nixosModules.stylix
      inputs.sops-nix.nixosModules.sops
      ./system/boot-secure.nix
      ./system/os.nix
      ./system/global.nix
      ./system/performance.nix
      ./system/security.nix
      ./system/monitoring.nix
      {nixpkgs.overlays = overlays;}
    ];

    # Simple OS configs for desktop systems without Framework-specific hardware
    desktopModules = [
      inputs.nixos-hardware.nixosModules.common-hidpi
      inputs.stylix.nixosModules.stylix
      inputs.sops-nix.nixosModules.sops
      ./system/os.nix
      ./system/global.nix
      ./system/performance.nix
      ./system/security.nix
      ./system/monitoring.nix
      {nixpkgs.overlays = overlays;}
    ];
  in {
    # Home Manager configurations
    homeConfigurations = {
      lars = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules =
          gnomeModules
          ++ [inputs.stylix.homeModules.stylix]
          ++ [./users/lars.nix];
        extraSpecialArgs = {
          inherit inputs;
        };
      };

      lars-hyprland = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules =
          hyprModules
          ++ [inputs.stylix.homeModules.stylix]
          ++ [./users/lars.nix];
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };

    # NixOS configurations
    nixosConfigurations = {
      framework = lib.nixosSystem {
        inherit system;
        modules =
          osModules
          ++ [
            inputs.nixos-hardware.nixosModules.framework-13-7040-amd
            ./hosts/framework/configuration.nix
          ];
        specialArgs = {inherit inputs;};
      };

      beelink = lib.nixosSystem {
        inherit system;
        modules =
          desktopModules
          ++ [
            ./hosts/beelink/configuration.nix
          ];
        specialArgs = {inherit inputs;};
      };
    };

    # Formatter
    formatter.${system} = pkgs.alejandra;

    # Custom packages
    packages.${system} =
      {
        dagger = inputs.dagger.packages.${system}.dagger;
        saws = inputs.saws.packages.${system}.default;
      }
      // (import ./pkgs pkgs);
  };
}
