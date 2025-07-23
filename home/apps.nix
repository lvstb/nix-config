# All applications consolidated
{ lib, pkgs, config, ... }:

{
  # Programs configuration
  # VSCode configuration moved to vscode.nix
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    dictionaries = [
      pkgs.hunspellDictsChromium.en_US
    ];
    extensions = [
      {id = "ocaahdebbfolfmndjeplogmgcagdmblk";}
      {id = "nngceckbapebfimnlniiiahkandclblb";}
      {id = "ecjfaoeopefafjpdgnfcjnhinpbldjij";}
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
      {id = "mnjggcdmjocbbbhaepdhchncahnbgone";}
    ];
  };

  # Shell based tools
  programs.home-manager.enable = true;
  programs.ripgrep.enable = true;
  programs.bat.enable = true;
  programs.fzf.enable = true;
  programs.zoxide.enable = true;
  programs.jq.enable = true;
  programs.eza.enable = true;
  programs.btop.enable = true;
  programs.gh.enable = true;
  programs.yazi.enable = true;
  programs.fd.enable = true;
  # direnv configuration moved to development.nix

  # Development languages and runtimes
  programs.go.enable = true;

  # Services
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
  
  home.packages = with pkgs; [
    # Core applications
    any-nix-shell
    nextcloud-client
    ghostty
    
    # Communication apps
    telegram-desktop
    discord
    whatsapp-for-linux
    slack

    # Text editors and IDEs
    obsidian
    claude-code
    code-cursor

    # Development - Languages (use specific versions)
    python311
    python311Packages.pip
    python311Packages.pipx
    nodejs_20
    nodePackages.pnpm
    nodePackages.yarn
    rustc
    cargo
    gcc
    
    # Development - Language servers (for nvim)
    gopls
    nixd
    yaml-language-server
    lua-language-server
    typescript-language-server
    terraform-ls
    marksman
    luajitPackages.luarocks
    
    # Development - Formatters and linters
    selene
    black
    prettier
    eslint
    alejandra
    stylua
    isort
    buf
    yamllint
    yamlfmt
    markdownlint-cli
    
    # Development - Tools
    httpie-desktop
    sops
    act
    kubectl
    terraform
    awscli2
    distrobox
    snyk

    # Office and productivity
    libreoffice-qt6-fresh
    bitwarden

    # Audio and video
    spotify
    hypnotix

    # File management and archives
    ncdu
    file-roller
    unzip
    
    # Terminal utilities
    wget
    file
    killall
    tree
  ];
  
  # Development environment variables
  home.sessionVariables = {
    # JAVA_HOME will be set by the JDK package when needed
  };
  
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$HOME/.opencode/bin"
  ];
}