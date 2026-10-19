# Pi coding agent: CLI + Claude marketplace extensions.
# Extensions live under ~/.pi/agent/npm/ (user scope). Pi does NOT auto-discover
# that directory: each extension must also be listed in the `packages` array of
# ~/.pi/agent/settings.json. That file is runtime state (pi rewrites theme,
# model, lastChangelogVersion, ...), so it stays unmanaged by Nix. On a fresh
# machine, register the Nix-provided extensions once:
#   pi install ~/.pi/agent/npm/pi-claude-marketplace
#   pi install ~/.pi/agent/npm/pi-subagents
#   pi install ~/.pi/agent/npm/pi-mcp-adapter
# These are recorded as paths relative to the settings file, so the symlinks
# below remain authoritative for content.
# Git-scope packages (~/.pi/agent/git/...) work the same way: superpowers is
# already registered in settings.json as git:github.com/obra/superpowers and
# resolves to the symlinked path below (source: the `superpowers` flake input,
# exposed as pkgs.pi-superpowers). Update with `nix flake update superpowers`.
# Note: `pi update --extensions` may overwrite these symlinks at runtime;
# the Nix-managed versions are restored on the next Home Manager switch.
# Skills under ~/.pi/agent/skills/ ARE auto-discovered (no registration).
# Auth: run `pi`, then `/login` and select "Claude Pro/Max" (enterprise SSO
# via browser). Credentials live in ~/.pi/agent/auth.json (runtime state).
{pkgs, ...}: {
  home.packages = [pkgs.pi-coding-agent];

  home.file.".pi/agent/npm/pi-claude-marketplace".source = pkgs.pi-claude-marketplace;
  home.file.".pi/agent/npm/pi-subagents".source = pkgs.pi-subagents;
  home.file.".pi/agent/npm/pi-mcp-adapter".source = pkgs.pi-mcp-adapter;
  home.file.".pi/agent/git/github.com/obra/superpowers".source = pkgs.pi-superpowers;

  # Skills (shared source with OpenCode/Claude Code), loaded from ~/.pi/agent/skills/
  home.file.".pi/agent/skills/install-anti-slop" = {
    source = ./opencode/skills/install-anti-slop;
    recursive = true;
  };
}
