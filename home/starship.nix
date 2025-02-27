{...}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
          format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$python$golang$nodejs$terraform$java$character";
          right_format = "$aws";
          nix_shell = {
            disabled = false;
            impure_msg = "";
            symbol = "";
            format = "[$symbol$state]($style) ";
            };
          python = {
            format = "[$virtualenv]($style) ";
            style = "bright-black";
            };
          golang = {
            symbol = "";
            format = "[$symbol($version )]($style)";
            };
          nodejs = {
            symbol = "󰎙";
            # style = "bold yellow"
            format = "[$symbol ($version )]($style)";
            };
          java = {
            symbol = " ";
            };
          terraform = {
            format = "[$workspace]($style)";
                };
          directory = {
            style = "blue";
           };
          character = {
            success_symbol = "[❯](purple)";
            error_symbol = "[❯](red)";
            vicmd_symbol = "[❮](green)";
            };
          git_branch = {
            format = "[$branch]($style)";
            style = "bright-black";
          };
          git_status = {
            format = "[[($conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
            style = "cyan";
            # conflicted = "​";
            # untracked = "​";
            # modified = "​";
            # staged = "​";
            # renamed = "​";
            # deleted = "​";
            stashed = "≡";
            };
          git_state = {
            format = "\([$state( $progress_current/$progress_total)]($style)\) ";
            style = "bright-black";
          };
          cmd_duration = {
            format = "[$duration]($style) ";
            style = "yellow";
          };
          aws = {
            format = "[$symbol($profile )(\($region\) )]($style)";
            style = "bold yellow";
            symbol = "󰫮 ";
            #[aws.region_aliases];
            #eu-west-1 = "eu";
            ## [aws.profile_aliases];
            ## picture-admin=picture;
          };
        };
  };
}
