# L1 - Quick Contract

- Mission: make safe, minimal, testable changes to this nix-config repo.
- Hard boundaries:
  - Never run destructive git operations (for example `git reset --hard`, forced history rewrites, or discarding user changes).
  - Never expose secrets from `secrets/`, `keys/`, or decrypted secret material in output/logs.
  - Never do unrelated refactors or opportunistic cleanups outside the requested scope.
- Where to edit:
  - `home/` -> Home Manager modules and shared user environment config.
  - `hosts/` -> host-specific machine definitions.
  - `system/` -> system-level NixOS modules and base system behavior.
  - `users/` -> user account/profile definitions wired into hosts.
  - `scripts/` -> helper scripts used by local workflows.
  - `home/opencode.nix` -> OpenCode/Home Manager integration and tool settings.
- Mandatory verify gates:
  - If any `.nix` file changed, run `nix fmt` (or `just fmt`) before completion.
  - Run `nix flake check` before claiming work is complete.

# L2 - Task Playbooks

## Home Manager module changes
- Task -> update user environment/module behavior.
- Touch -> primarily `home/` (and `users/` only when wiring/selection changes are required).
- Verify -> `nix fmt` when Nix changed, then `nix flake check`; run targeted eval/build command if impacted by change.
- Done criteria -> modules evaluate cleanly, checks pass, and scope is limited to requested HM behavior.

## Host-specific or system changes
- Task -> adjust machine-specific config or shared NixOS system behavior.
- Touch -> `hosts/` for host overrides, `system/` for shared system modules, `users/` only if host-user wiring changes.
- Verify -> `nix fmt` when Nix changed, `nix flake check`, and run relevant host/user command when applicable.
- Done criteria -> target host/system path is updated, evaluations/checks pass, no unrelated host drift introduced.

## OpenCode config changes (`home/opencode.nix`)
- Task -> modify OpenCode-related Home Manager configuration.
- Touch -> `home/opencode.nix` (plus narrowly related files only if required by imports/options).
- Verify -> `nix fmt` when Nix changed, then `nix flake check`; run a user-level apply command if needed.
- Done criteria -> OpenCode config evaluates, checks pass, and behavior matches requested change only.

## Ambiguity handling
- If instructions conflict, prefer the stricter safety path (smaller change, less risk, no destructive action).
- Ask one targeted clarifying question only when the answer materially changes files touched, safety posture, or validation path.

## Flake package wiring
- When adding a package from a flake input for regular use in `home.packages` or `environment.systemPackages`, expose it through `flake.nix` overlays first and consume it as `pkgs.<name>` in modules instead of referencing `inputs.<name>.packages...` directly at the use site.
- If useful for direct builds, also expose the package under `packages.${system}` in `flake.nix`, but keep module package lists using `pkgs.<name>`.

## Secret handling
- Define secrets in `system/secrets.nix` via `sops.secrets`, not in `home/`, `hosts/`, or committed config files.
- Consume secrets at runtime from `/run/secrets/<name>` or the declared secret path, not through `builtins.readFile`, `writeText`, `toJSON`, or other Nix store materialization.
- Use environment-variable export snippets only for runtime injection into tools and shells.
- Reserve explicit file paths for tools that require a real file on disk, such as SSH keys.
- Never copy secret values into `home.file`, generated dotfiles, logs, diffs, or command output.

# L3 - Deep Reference

## Useful commands
- `just fmt` -> format repo Nix and related files.
- `just user lars` -> apply/evaluate user config flow for `lars`.
- `just deploy <hostname>` -> deploy to a specific host.

## Edge cases
- Unknown host with `just user <name>`: do not guess host-specific behavior; inspect `justfile`/host mappings first and ask one targeted question if target selection is ambiguous.
- Secrets caution: never print secret values, decrypted files, private keys, or full secret diffs.
- Clarifying-question threshold: ask one targeted question only if uncertainty would materially change implementation or verification.
