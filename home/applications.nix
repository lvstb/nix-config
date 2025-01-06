# applications.nix
{ lib, pkgs, ... }: {

  # Use lib.mkDefault where possible so user config can override without lib.mkForce

  # Install packages via programs.* where possible
  # May include extra config OOTB that the package does not
  programs.vscode.enable = lib.mkDefault true;
  programs.chromium = {
    enable = lib.mkDefault true;
    package = pkgs.ungoogled-chromium;
    dictionaries = [
      pkgs.hunspellDictsChromium.en_US
    ];
    extensions = [
      { id = "ocaahdebbfolfmndjeplogmgcagdmblk"; }
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
      { id = "ecjfaoeopefafjpdgnfcjnhinpbldjij"; }
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }
    ];
  };
    
  # Shell based tools
  programs.home-manager.enable = lib.mkDefault true;
  programs.tmux.enable = lib.mkDefault true;
  programs.ripgrep.enable = lib.mkDefault true;
  programs.neovim.enable = lib.mkDefault true;


  # Languages
  # programs.java.enable = lib.mkDefault true;
  # programs.java.package = lib.mkDefault pkgs.jdk17_headless;
  programs.go.enable = lib.mkDefault true;


  home.packages = lib.mkBefore (with pkgs; [
    #Communication and social
    telegram-desktop
    discord
    whatsapp-for-linux
    slack

    #Text editors and IDEs
    zed-editor
    obsidian
    
    #Programming Languages
    python3
    python3Packages.pip
    python3Packages.pipx
    nodePackages_latest.pnpm
    nodePackages_latest.yarn
    nodePackages_latest.nodejs
    gcc
    cargo
    
    #Version control and dev tools
    gh 
    httpie-desktop
    kubernetes-helm
    kubectl
    tmux
    distrobox
    snyk
    terraform
    awscli
    
    #File mgmt and archives
    yazi 
    file-roller
    ncdu
    nextcloud-client
        
    #Terminal utilities
    wget
    file
    jq
    killall
    eza
    zoxide
    fzf
    tree 
    btop
    ripgrep
    bat
    # inputs.ghostty.packages."${system}".default

    #Audio and video
    spotify
    hypnotix

    #Productivity
    libreoffice-qt6-fresh
    bitwarden

  ]);

}
