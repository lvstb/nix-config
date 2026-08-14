# Pi coding agent: CLI + Claude marketplace extensions.
# Extensions live under ~/.pi/agent/npm/ (user scope, auto-discovered by pi).
# Note: `pi update --extensions` may overwrite these symlinks at runtime;
# the Nix-managed versions are restored on the next Home Manager switch.
# Auth: run `pi`, then `/login` and select "Claude Pro/Max" (enterprise SSO
# via browser). Credentials live in ~/.pi/agent/auth.json (runtime state).
{pkgs, ...}: {
  home.packages = [pkgs.pi-coding-agent];

  home.file.".pi/agent/npm/pi-claude-marketplace".source = pkgs.pi-claude-marketplace;
  home.file.".pi/agent/npm/pi-subagents".source = pkgs.pi-subagents;
  home.file.".pi/agent/npm/pi-mcp-adapter".source = pkgs.pi-mcp-adapter;
}
