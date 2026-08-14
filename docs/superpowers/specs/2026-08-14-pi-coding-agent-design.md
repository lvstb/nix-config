# Design: Pi coding agent with Claude plugin access

Date: 2026-08-14

## Goal

Install the [Pi coding agent](https://pi.dev) CLI (`@earendil-works/pi-coding-agent`) via
Home Manager, fully Nix-managed, together with the extensions needed to use Claude Code
plugin marketplaces from within Pi:

- `pi-claude-marketplace` (`/claude:plugin` commands, Claude Code marketplace compatibility)
- `pi-subagents` (required for Claude plugin *agents* components)
- `pi-mcp-adapter` (required for Claude plugin *MCP server* components)

Authentication to Claude (enterprise) is interactive: the user runs `pi`, then `/login`,
selects "Claude Pro/Max" and authorizes their enterprise org in the browser. No auth
material in the Nix config. Azure Foundry (used by `home/claude.nix` for Claude Code) is
out of scope for Pi — Pi does not document Foundry support.

## Components

### 1. `pkgs/pi-coding-agent.nix`

`buildNpmPackage` packaging of `@earendil-works/pi-coding-agent@0.84.2` from the npm
registry tarball:

- The tarball ships pre-built `dist/` and an `npm-shrinkwrap.json` (usable directly as
  the lockfile for `npmDepsHash` — copy it to `package-lock.json` in `postPatch` if
  needed).
- `bin.pi = dist/cli.js`, `#!/usr/bin/env node`, ESM; runtime is `pkgs.nodejs`.
- No build step required beyond installing deps (`dontBuild = true`); the published
  `dist/` is what ships to users.
- `@silvia-odwyer/photon-node` ships a wasm file — plain file, no native compilation
  expected. If a native binding turns out to be required, handle it during
  implementation.

Wired into `pkgs/default.nix` as `pi-coding-agent`, which automatically exposes it via
the existing overlay (`pkgs.pi-coding-agent`) and `packages.${system}` (per the repo's
flake-package-wiring rule in AGENTS.md).

### 2. Pi extensions, installed declaratively

Pi auto-discovers user-scope packages from `~/.pi/agent/npm/<name>/` (the same location
`pi install npm:<name>` uses). Each extension is an npm package with a `pi` manifest key
in `package.json`; extensions are TypeScript loaded through pi's bundled `jiti`, so no
compilation step is needed — but runtime dependencies must be present in the package's
`node_modules`.

Versions (current at time of writing):

| Package | Version | Runtime deps |
|---|---|---|
| `pi-claude-marketplace` | 0.14.0 | isomorphic-git, proper-lockfile, write-file-atomic |
| `pi-subagents` | 0.49.0 | jiti, typebox, yaml |
| `pi-mcp-adapter` | 2.25.0 | @modelcontextprotocol/*, ajv, zod, etc. |

Approach per package: `buildNpmPackage` with `dontBuild`, installing the package tree
plus production `node_modules` into `$out/lib/node_modules/<name>`, then symlink (via
`home.file` or an activation-free `home.file` source) into `~/.pi/agent/npm/<name>`.
If a package ships no lockfile, fall back to `npm install --omit=dev` inside the build
(fixed by `npmDepsHash` where possible; otherwise document the hash flow).

Note on updates: because these live under `~/.pi/agent/npm/`, `pi update --extensions`
may try to manage them. That is acceptable; the Nix-managed versions reappear on the
next Home Manager switch. Document this in the module comment.

### 3. `home/pi.nix`

Home Manager module:

```nix
{pkgs, ...}: {
  home.packages = [pkgs.pi-coding-agent];

  home.file.".pi/agent/npm/pi-claude-marketplace".source = ...;
  home.file.".pi/agent/npm/pi-subagents".source = ...;
  home.file.".pi/agent/npm/pi-mcp-adapter".source = ...;
}
```

Nothing else: no settings.json, no auth config.

### 4. `flake.nix`

Add `./home/pi.nix` to `baseHomeModules` (covers both the GNOME and Hyprland user
configurations). No other flake changes needed — the overlay and `packages` exposure
already flow through `pkgs/default.nix`.

## Data flow

1. `nix` build: npm tarballs → Nix store paths (pi binary + 3 extension trees).
2. Home Manager switch: `pi` on `PATH`; `~/.pi/agent/npm/*` symlinked to store.
3. Runtime: user runs `pi` → `/login` (Claude enterprise via browser SSO) →
   `/claude:plugin bootstrap` / `/claude:plugin install <plugin>@<marketplace>` →
   `/reload`.

## Error handling / edge cases

- **photon-node wasm**: plain asset file, expected to work; verified by smoke test.
- **Extension deps drift from pi's bundled modules**: pi-subagents reuses pi's already
  loaded modules where possible; version pinning above matches current compatibility.
- **Pi version bumps**: versions are pinned; updating means bumping version + hashes in
  one place (`pkgs/pi-coding-agent.nix` and `home/pi.nix` or a shared `let` in
  `pkgs/default.nix`).

## Verification

1. `nix fmt`
2. `nix flake check`
3. `nix build .#pi-coding-agent` and run `./result/bin/pi --version`
4. After `just user lars`: `pi list` shows the three extensions; `pi` starts.

## Out of scope

- Pre-installing Claude marketplace plugins (done interactively via `/claude:plugin`).
- Azure Foundry integration for Pi.
- Pi settings/themes/keybindings customization.
