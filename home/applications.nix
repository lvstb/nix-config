# applications.nix
{
  lib,
  pkgs,
  ...
}: {
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
      {id = "ocaahdebbfolfmndjeplogmgcagdmblk";}
      {id = "nngceckbapebfimnlniiiahkandclblb";}
      {id = "ecjfaoeopefafjpdgnfcjnhinpbldjij";}
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
      {id = "mnjggcdmjocbbbhaepdhchncahnbgone";}
    ];
  };
    
  # Shell based tools
  programs.home-manager.enable = lib.mkDefault true;
  programs.ripgrep.enable = lib.mkDefault true;
  # programs.neovim.enable = lib.mkDefault true;
  programs.bat.enable = lib.mkDefault true;
  programs.fzf.enable = lib.mkDefault true;
  programs.zoxide.enable = lib.mkDefault true;
  programs.jq.enable = lib.mkDefault true;
  programs.eza.enable = lib.mkDefault true;
  programs.btop.enable = lib.mkDefault true;
  programs.gh.enable = lib.mkDefault true;
  programs.yazi.enable = lib.mkDefault true;
  programs.direnv = {
    enable = true;
    config = {
      "load_dotenv" = true;
    };
  };

  # Languages
  # programs.java.enable = lib.mkDefault true;
  # programs.java.package = lib.mkDefault pkgs.jdk17_headless;
  programs.go.enable = lib.mkDefault true;
  programs.zed-editor.enable = lib.mkDefault true;

  services.nextcloud-client.enable = lib.mkDefault true;
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.packages = lib.mkBefore (with pkgs; [
    #Communication and social
    telegram-desktop
    discord
    whatsapp-for-linux
    slack

    #Text editors and IDEs
    any-nix-shell
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
    nextcloud-client

    #language servers
    gopls
    nixd
    yaml-language-server
    lua-language-server
    typescript-language-server
    json-language-server

    #formatters and linters
    selene
    #Version control and dev tools
    httpie-desktop
    kubectl
    distrobox
    snyk
    terraform
    awscli2
    sops
    act

    #File mgmt and archives
    ncdu
    file-roller
    unzip

    #Terminal utilities
    wget
    file
    killall
    tree

    #Audio and video
    spotify
    hypnotix

    #Productivity
    libreoffice-qt6-fresh
    bitwarden
  ]);
}
