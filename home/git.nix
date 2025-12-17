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

    # Signing configuration for personal commits
    signing = {
      key = "~/.ssh/id_personal";
      signByDefault = true;
    };

    settings = {
      # Main user configuration
      user = {
        name = "Lars Van Steenbergen";
        email = "lars@wingu.dev";
      };
      
      core = {
        editor = "nvim";
        excludesfile = "~/.gitignore_global";
        sshCommand = "ssh -i ~/.ssh/id_personal";
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      gpg.format = "ssh";
      
      # aliases for git commands
      alias = {
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

    # Work-specific configuration when in DPG directory
    includes = [
      {
        condition = "gitdir:~/DPG/";
        contents = {
          user = {
            name = "Lars Van Steenbergen";
            email = "lars.van.steenbergen@persgroep.net";
            signingkey = "~/DPG/.ssh/id_dpgmedia";
          };
          core.sshCommand = "ssh -i ~/DPG/.ssh/id_dpgmedia";
          commit.gpgSign = true;
          gpg.format = "ssh";
        };
      }
    ];

  };

  # Delta configuration moved to separate program
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      features = "side-by-side";
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