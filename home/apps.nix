# All applications consolidated
{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: {
  # Programs configuration
  # VSCode configuration moved to vscode.nix
  # Chromium replaced with Helium - see home.packages for helium installation

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

  # Services - Nextcloud client disabled (no secrets configured)
  # services.nextcloud-client = {
  #   enable = true;
  #   startInBackground = true;
  # };

  home.packages = with pkgs; [
    # Core applications
    ghostty
    nur.repos.Ev357.helium

    # Communication apps
    telegram-desktop
    discord
    wasistlos
    slack

    # Text editors and IDEs
    obsidian
    claude-code
    code-cursor
    kiro
    opencode
    inputs.saws.packages.${pkgs.system}.default
    # Development - Languages (use specific versions)
    python312
    python312Packages.pip
    python312Packages.pipx
    nodejs_24
    nodePackages.pnpm
    nodePackages.yarn
    bun
    rustc
    cargo
    gcc
    pre-commit

    # Development - Language servers (for nvim)
    gopls
    nixd
    yaml-language-server
    lua-language-server
    typescript-language-server
    terraform-ls
    marksman
    luajitPackages.luarocks
    jetbrains.idea
    # Development - Formatters and linters
    hadolint
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
    # github-copilot-cli
    httpie-desktop
    sops
    act
    kubectl
    terraform
    awscli2
    distrobox
    snyk
    just
    cloudsmith-cli

    # Office and productivity
    libreoffice-qt6-fresh
    bitwarden-desktop

    # Audio and video
    spotify
    hypnotix
    pamixer

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
