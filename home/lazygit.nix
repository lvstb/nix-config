{lib, ...}: {
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        #branchLogCmd =  'git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium --oneline {{branchName}} --'
        pagers = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          }
        ];
        disableForcePushing = true;
        commit = {
          signOff = false;
        };
        merging = {
          # only applicable to unix users
          manualCommit = false;
          # extra args passed to `git merge`, e.g. --no-ff
          # args= '' ;
        };
        log = {
          # one of date-order, author-date-order, topo-order.
          # topo-order makes it easier to read the git log graph, but commits may not
          # appear chronologically. See https://git-scm.com/docs/git-log#_commit_ordering
          order = "topo-order";
          # one of always, never, when-maximised
          # this determines whether the git graph is rendered in the commits panel
          showGraph = "when-maximised";
          # displays the whole git graph by default in the commits panel (equivalent to passing the `--all` argument to `git log`)
          showWholeGraph = false;
        };
        autoFetch = true;
        autoRefresh = true;
        # allBranchesLogCmds = "git log --graph --all --color=always --abbrev-commit --decorate --date=relative  --pretty=medium";
        overrideGpg = false; # prevents lazygit from spawning a separate process when using GPG
        parseEmoji = false;
      };
      customCommands = [
        {
          key = "C";
          command = "git commit -m '{{ .Form.Type }}{{if .Form.Scopes}}({{ .Form.Scopes }}){{end}}: {{ .Form.Description }}'";
          description = "Conventional commits";
          context = "files";
          prompts = [
            {
              type = "menu";
              title = "Select the type of change you are committing.";
              key = "Type";
              options = [
                {
                  name = "Feature";
                  description = "a new feature";
                  value = "feat";
                }
                {
                  name = "Fix";
                  description = "a bug fix";
                  value = "fix";
                }
                {
                  name = "Documentation";
                  description = "Documentation only changes";
                  value = "docs";
                }
                {
                  name = "Styles";
                  description = "Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)";
                  value = "style";
                }
                {
                  name = "Code Refactoring";
                  description = "A code change that neither fixes a bug nor adds a feature";
                  value = "refactor";
                }
                {
                  name = "Performance Improvements";
                  description = "A code change that improves performance";
                  value = "perf";
                }
                {
                  name = "Tests";
                  description = "Adding missing tests or correcting existing tests";
                  value = "test";
                }
                {
                  name = "Builds";
                  description = "Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)";
                  value = "build";
                }
                {
                  name = "Continuous Integration";
                  description = "Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)";
                  value = "ci";
                }
                {
                  name = "Chores";
                  description = "Other changes that don't modify src or test files";
                  value = "chore";
                }
                {
                  name = "Reverts";
                  description = "Reverts a previous commit";
                  value = "revert";
                }
              ];
            }
            {
              type = "input";
              title = "Enter the scope(s) of this change.";
              key = "Scopes";
            }
            {
              type = "input";
              title = "Enter the short description of the change.";
              key = "Description";
            }
            {
              type = "confirm";
              title = "Is the commit message correct?";
              body = "{{ .Form.Type }}{{if .Form.Scopes}}({{ .Form.Scopes }}){{end}}: {{ .Form.Description }}";
            }
          ];
        }
      ];
      gui = {
        # theme = [
        #  lib.mkDefault {activeBorderColor = ["#7daea3" "bold"];}
        #  lib.mkDefault {inactiveBorderColor = ["#ebdbb2"];}
        #  lib.mkDefault {optionsTextColor = ["#89b482"];}
        #  lib.mkDefault {selectedLineBgColor = ["#313244"];}
        #  lib.mkDefault {cherryPickedCommitBgColor = ["#45475a"];}
        #  lib.mkDefault {cherryPickedCommitFgColor = ["#d3869b"];}
        #  lib.mkDefault {unstagedChangesColor = ["#ea6962"];}
        #  lib.mkDefault {defaultFgColor = ["#ebdbb2"];}
        #  lib.mkDefault {searchingActiveBorderColor = ["#a9b665"];}
        # ];
        nerdFontsVersion = "3";
      };
    };
  };
}
