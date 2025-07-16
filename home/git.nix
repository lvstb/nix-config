# {
#   # lib,
#   # userfullname,
#   # useremail,
#   ...
# }
{lib, config, ...}: {
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

    userName = builtins.readFile "/run/secrets/user_full_name";
    userEmail = builtins.readFile "/run/secrets/email_wingu_address";

    includes = [
      {
        # use a different config for work
        path = "~/DPG/.gitconfig";
        condition = "gitdir:~/DPG/";
      }
    ];

    extraConfig = {
      core.editor = "nvim";
      core.excludesfile = "~/.gitignore_global";
      core.sshCommand = "ssh -i ~/.ssh/id_ed25519_personal";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      gpg.format = "ssh";
    };

    signing = {
      key = "/run/secrets/personal_ssh_private_key";
      signByDefault = true;
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

  home.activation.createDPGDir = lib.hm.dag.entryBefore ["writeBoundary"] ''mkdir -p $HOME/DPG'';

    home.file = {      "DPG/.gitconfig" = {
        text = ''
          [core]
            sshCommand = ssh -i /run/secrets/dpgmedia_ssh_private_key

          [user]
            email = ${builtins.readFile "/run/secrets/email_work_address"}
            signingkey = /run/secrets/dpgmedia_ssh_private_key
          [commit]
            gpgSign = true
        '';
      };
    };}
