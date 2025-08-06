{ config, pkgs, lib, ... }:

{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    
    config = {
      global = {
        # Silence direnv logs
        silent = false;
        # Warn when .envrc takes too long
        warn_timeout = "30s";
        # Hide env diff
        hide_env_diff = false;
      };
      
      whitelist = {
        # You can add trusted directories here
        # prefix = [ "~/projects" ];
      };
    };
    
    stdlib = ''
      # Custom direnv functions
      
      # Layout for Python projects
      layout_python() {
        if [[ -d ".venv" ]]; then
          source .venv/bin/activate
        elif [[ -f "requirements.txt" ]]; then
          python -m venv .venv
          source .venv/bin/activate
          pip install -r requirements.txt
        fi
      }
      
      # Layout for Node projects
      layout_node() {
        PATH_add node_modules/.bin
        if [[ ! -d "node_modules" && -f "package.json" ]]; then
          npm install
        fi
      }
      
      # Use flake with automatic reload
      use_flake() {
        watch_file flake.nix
        watch_file flake.lock
        eval "$(nix print-dev-env --profile "$(direnv_layout_dir)/flake-profile")"
      }
    '';
  };
  
  # Global gitignore for direnv files
  home.file.".config/git/ignore".text = lib.mkAfter ''
    # Direnv
    .direnv/
    .envrc
  '';
}