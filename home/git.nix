# {
#   # lib,
#   # userfullname,
#   # useremail,
#   ...
# }
{lib, config, pkgs, ...}: {
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -f ~/.gitconfig
  '';

  programs.git = {
    enable = true;
    lfs.enable = true;

    # Include the main git config from SOPS template
    includes = [
      {
        path = "/run/secrets/git-config-secrets";
      }
      {
        # use a different config for work
        path = "/run/secrets/git-config-work";
        condition = "gitdir:~/DPG/";
      }
    ];

    extraConfig = {
      core.editor = "nvim";
      core.excludesfile = "~/.gitignore_global";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
    };

    delta = {
      enable = true;
      options = {
        features = "side-by-side";
      };
    };

    aliases = {
      # common aliases
      br = "branch";
      co = "checkout";
      st = "status";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      cm = "commit -m";
      ca = "commit -am";
      dc = "diff --cached";
      amend = "commit --amend -m";

      # aliases for submodule
      update = "submodule update --init --recursive";
      foreach = "submodule foreach";
    };
  };

  # Create DPG directory for work projects
  home.activation.createDPGDir = lib.hm.dag.entryBefore ["writeBoundary"] ''
    mkdir -p $HOME/DPG
  '';

  # Global gitignore file
  home.file.".gitignore_global".text = ''
    # OS generated files
    .DS_Store
    .DS_Store?
    ._*
    .Spotlight-V100
    .Trashes
    ehthumbs.db
    Thumbs.db

    # Editor files
    *.swp
    *.swo
    *~
    .idea/
    .vscode/
    *.sublime-project
    *.sublime-workspace

    # Environment files
    .env
    .env.local
    .env.*.local
    .direnv/
    .envrc

    # Temporary files
    *.tmp
    *.temp
    *.log
    
    # Build artifacts
    dist/
    build/
    *.pyc
    __pycache__/
    node_modules/
    .cache/
  '';}
