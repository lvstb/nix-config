# {
#   # lib,
#   # userfullname,
#   # useremail,
#   ...
# }
{ lib, ... }:
let
  userfullname = "Lars van Steenbergen";
  useremail = "lars@wingu.dev";


in
{
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f ~/.gitconfig
  '';

  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = userfullname;
    userEmail = useremail;

    includes = [
      {
        # use a different config for work
        path = "~/DPG/.ssh/.gitconfig";
        condition = "gitdir:~/DPG/";
      }
    ];

    extraConfig = {
      core.editor = "nvim";
      core.excludesfile = "~/.gitignore_global";
      core.sshCommand = "ssh -i ~/.ssh/id_ed25519";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      gpg.format = "ssh";
    };

    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwx7yjdiTjQbqjlkUyoSI7SI3SQmw1NQeQgLOaIMSaB";
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

  home.file = {
    "DPG/.ssh/.gitconfig" = {
      text = ''
        [core]
          sshCommand = ssh -i ~/DPG/.ssh/id_ed25519

        [user]
          email = lars.van.steenbergen@persgroep.net
          signingkey = ~/DPG/.ssh/id_ed25519
        [commit]
          gpgSign = true
      '';
    };
  };
}
