# Pi Coding Agent Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Install the Pi coding agent CLI and its Claude-marketplace extensions declaratively through this nix-config (Home Manager), so the user can run `pi`, log in with their Claude enterprise account, and install Claude Code plugins via `/claude:plugin`.

**Architecture:** `pkgs/pi-coding-agent.nix` packages the published npm tarball with `buildNpmPackage` (uses its shipped `npm-shrinkwrap.json` as lockfile). Three Pi extensions (`pi-claude-marketplace`, `pi-subagents`, `pi-mcp-adapter`) are fetchurl'd as npm tarballs and built with a small shared `mkPiExtension` helper (`pkgs/pi-extensions.nix`) that runs `npm install --omit=dev` against a repo-pinned `package-lock.json`. `home/pi.nix` puts the CLI on PATH and links the extensions into `~/.pi/agent/npm/` where Pi auto-discovers user-scope packages.

**Tech Stack:** Nix (buildNpmPackage, fetchurl), Home Manager, npm.

**Spec:** `docs/superpowers/specs/2026-08-14-pi-coding-agent-design.md`

**Known facts (already verified):**

- Tarball URLs and sha256 (SRI):
  - pi-coding-agent 0.84.2: `https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.84.2.tgz` → `sha256-lbiZzXsaDB8BdMe/M6tCdDXjVTp9H0dWZhqpx/Gmj/o=`
  - pi-claude-marketplace 0.14.0: `https://registry.npmjs.org/pi-claude-marketplace/-/pi-claude-marketplace-0.14.0.tgz` → `sha256-fRgINRoaWf77Er3Yjka7SG9fgRUAjxkMJup0Ny88AxM=`
  - pi-subagents 0.49.0: `https://registry.npmjs.org/pi-subagents/-/pi-subagents-0.49.0.tgz` → `sha256-Yl8uNzdGupibcf1VlZmFJbjDXiVPtwYsiZJqyb65xOU=`
  - pi-mcp-adapter 2.25.0: `https://registry.npmjs.org/pi-mcp-adapter/-/pi-mcp-adapter-2.25.0.tgz` → `sha256-JLgOGPUsgT9466B4hCX5EFvD9d0rkwCwdkE7JQtobgQ=`
- pi-coding-agent tarball ships `npm-shrinkwrap.json` and prebuilt `dist/`; `bin.pi = dist/cli.js`; deps are pure JS + a wasm asset (`@silvia-odwyer/photon-node`).
- None of the three extensions ship a lockfile → each needs a repo-pinned lockfile under `pkgs/pi-extensions/`.
- Extensions load TypeScript via pi's bundled `jiti` → no compile step, but each package's runtime `node_modules` must be present alongside its sources.
- `flake.nix` already has overlay `(final: prev: import ./pkgs prev)` and `packages.${system} = ... // (import ./pkgs pkgs)`, so adding an attr to `pkgs/default.nix` exposes both `pkgs.<name>` and `.#<name>` with no flake change.
- `baseHomeModules` in `flake.nix` is shared by both homeConfigurations (`lars`, `lars-hyprland`).

---

### Task 1: Package pi-coding-agent

**Files:**
- Create: `pkgs/pi-coding-agent.nix`
- Modify: `pkgs/default.nix`

- [ ] **Step 1: Create the package expression**

Create `pkgs/pi-coding-agent.nix`:

```nix
{pkgs}: let
  version = "0.84.2";
in
  pkgs.buildNpmPackage {
    pname = "pi-coding-agent";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-${version}.tgz";
      hash = "sha256-lbiZzXsaDB8BdMe/M6tCdDXjVTp9H0dWZhqpx/Gmj/o=";
    };

    # The tarball ships npm-shrinkwrap.json; buildNpmPackage needs package-lock.json
    postUnpack = ''
      cp $sourceRoot/npm-shrinkwrap.json $sourceRoot/package-lock.json
    '';

    npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

    # dist/ is prebuilt and published; nothing to compile
    dontBuild = true;

    # photon-node ships a wasm asset; skip the binary-pruning shopt if it errors
    npmPruneFlags = ["--omit=dev"];

    meta = {
      description = "Pi: minimal terminal coding agent CLI";
      homepage = "https://pi.dev";
      mainProgram = "pi";
    };
  }
```

- [ ] **Step 2: Wire into pkgs/default.nix**

In `pkgs/default.nix`, add inside the attrset (keep alphabetical-ish placement, after `jlink-jabra`):

```nix
  pi-coding-agent = import ./pi-coding-agent.nix {inherit pkgs;};
```

- [ ] **Step 3: Fix npmDepsHash by building once**

Run:
```bash
nix build .#pi-coding-agent 2>&1 | tail -20
```
Expected: FAIL with a hash mismatch message showing the real `npmDepsHash` (`got: sha256-...`). Copy that hash into `pkgs/pi-coding-agent.nix` replacing the placeholder, then re-run the build.

Expected after fix: build succeeds, `./result/bin/pi --version` prints `0.84.2` (run it to verify).

If the build fails for a reason other than the hash (e.g. `npm prune` choking on the wasm asset, or photon-node needing a postinstall), read the error, make the minimal fix (e.g. `dontNpmPrune = true;` or `npmFlags = ["--ignore-scripts"];` + verify the CLI still runs), and re-run.

- [ ] **Step 4: Commit**

```bash
git add pkgs/pi-coding-agent.nix pkgs/default.nix
git commit -m "feat: package pi-coding-agent"
```

---

### Task 2: Extension lockfiles

None of the three extension tarballs ship a lockfile, so pin them in-repo.

**Files:**
- Create: `pkgs/pi-extensions/pi-claude-marketplace/package.json`
- Create: `pkgs/pi-extensions/pi-claude-marketplace/package-lock.json`
- Create: `pkgs/pi-extensions/pi-subagents/package.json`
- Create: `pkgs/pi-extensions/pi-subagents/package-lock.json`
- Create: `pkgs/pi-extensions/pi-mcp-adapter/package.json`
- Create: `pkgs/pi-extensions/pi-mcp-adapter/package-lock.json`

- [ ] **Step 1: Create package.json stubs (deps copied from each tarball's package.json)**

`pkgs/pi-extensions/pi-claude-marketplace/package.json`:
```json
{
  "name": "pi-claude-marketplace",
  "version": "0.14.0",
  "dependencies": {
    "isomorphic-git": "^1.38.1",
    "proper-lockfile": "^4.1.2",
    "write-file-atomic": "^8.0.0"
  }
}
```

`pkgs/pi-extensions/pi-subagents/package.json`:
```json
{
  "name": "pi-subagents",
  "version": "0.49.0",
  "dependencies": {
    "jiti": "2.7.0",
    "typebox": "1.1.38",
    "yaml": "2.8.3"
  }
}
```

`pkgs/pi-extensions/pi-mcp-adapter/package.json`:
```json
{
  "name": "pi-mcp-adapter",
  "version": "2.25.0",
  "dependencies": {
    "@modelcontextprotocol/client": "2.0.0",
    "@modelcontextprotocol/core": "2.0.0",
    "@modelcontextprotocol/ext-apps": "^1.2.2",
    "@napi-rs/keyring": "^1.3.0",
    "ajv": "^8.17.1",
    "ajv-formats": "^3.0.1",
    "cross-spawn": "^7.0.6",
    "open": "^10.2.0",
    "recheck": "^4.5.0",
    "smol-toml": "^1.6.1",
    "strip-json-comments": "^5.0.3",
    "zod": "^3.25.0 || ^4.0.0"
  }
}
```

- [ ] **Step 2: Generate lockfiles**

Run:
```bash
for d in pi-claude-marketplace pi-subagents pi-mcp-adapter; do
  (cd pkgs/pi-extensions/$d && npm install --package-lock-only --ignore-scripts)
done
```
Expected: a `package-lock.json` appears in each of the three directories, no errors.

- [ ] **Step 3: Commit**

```bash
git add pkgs/pi-extensions/
git commit -m "chore: pin pi extension dependencies"
```

---

### Task 3: mkPiExtension builder + three extension packages

**Files:**
- Create: `pkgs/pi-extensions.nix`
- Modify: `pkgs/default.nix`

- [ ] **Step 1: Create pkgs/pi-extensions.nix**

```nix
# Builds Pi extension packages from their npm tarballs.
# Extensions are TypeScript loaded by pi's bundled jiti, so no compile step;
# but each package's runtime dependencies must be present in node_modules
# next to its sources. Lockfiles are pinned in pkgs/pi-extensions/<name>/.
{pkgs}: let
  mkPiExtension = {
    name,
    version,
    hash,
  }:
    pkgs.buildNpmPackage {
      pname = name;
      inherit version;

      src = pkgs.fetchurl {
        url = "https://registry.npmjs.org/${name}/-/${name}-${version}.tgz";
        inherit hash;
      };

      postUnpack = ''
        cp ${./pi-extensions/${name}/package-lock.json} $sourceRoot/package-lock.json
      '';

      npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

      dontBuild = true;

      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp -r . $out/
        runHook postInstall
      '';
    };
in {
  pi-claude-marketplace = mkPiExtension {
    name = "pi-claude-marketplace";
    version = "0.14.0";
    hash = "sha256-fRgINRoaWf77Er3Yjka7SG9fgRUAjxkMJup0Ny88AxM=";
  };

  pi-subagents = mkPiExtension {
    name = "pi-subagents";
    version = "0.49.0";
    hash = "sha256-Yl8uNzdGupibcf1VlZmFJbjDXiVPtwYsiZJqyb65xOU=";
  };

  pi-mcp-adapter = mkPiExtension {
    name = "pi-mcp-adapter";
    version = "2.25.0";
    hash = "sha256-JLgOGPUsgT9466B4hCX5EFvD9d0rkwCwdkE7JQtobgQ=";
  };
}
```

- [ ] **Step 2: Wire into pkgs/default.nix**

In `pkgs/default.nix`, change the attrset head and add the extensions. Replace:

```nix
pkgs: {
```

with:

```nix
pkgs:
{
```

and add at the end of the attrset (before the closing `}`):

```nix
  // (import ./pi-extensions.nix {inherit pkgs;})
```

so the full file becomes:

```nix
# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs:
{
  pipx = pkgs.python312Packages.pipx.overrideAttrs (_: {
    dontUsePytestCheck = true;
  });

  eid-mw = pkgs.eid-mw.overrideAttrs (old: rec {
    version = "5.1.28";
    src = pkgs.fetchurl {
      url = "https://eid.belgium.be/sites/default/files/software/eid-mw-${version}-v${version}.tar.gz";
      hash = "sha256-+5le3GvZfrM7ejuBMgcGJd0VJnpnA59+CKdkc1dH+VY=";
    };
    postPatch = ''
      sed 's@m4_esyscmd_s(.*,@[${version}],@' -i configure.ac
      substituteInPlace configure.ac \
        --replace-fail 'p11kitcfdir=""' 'p11kitcfdir="'$out/share/p11-kit/modules'"'
    '';
  });

  jlink-jabra = import ./jlink.nix {inherit pkgs;};

  pi-coding-agent = import ./pi-coding-agent.nix {inherit pkgs;};

  # zscaler = import ./zscaler.nix {inherit pkgs;};
}
// (import ./pi-extensions.nix {inherit pkgs;})
```

- [ ] **Step 3: Fix npmDepsHash for each extension**

Run:
```bash
nix build .#pi-subagents 2>&1 | tail -20
```
Copy the `got:` hash into the `pi-subagents` entry, re-run until it builds. Repeat for `.#pi-claude-marketplace` and `.#pi-mcp-adapter` (fill each placeholder hash, rebuild).

Expected: all three build; each `./result/` contains the package sources plus `node_modules/`.

Note: `@napi-rs/keyring` (dep of pi-mcp-adapter) ships prebuilt native binaries — if the build fails on it, read the error and make the minimal fix (most likely `npmFlags = ["--ignore-scripts"];` since the prebuilds are downloaded as separate optional deps, not postinstall).

- [ ] **Step 4: Commit**

```bash
git add pkgs/pi-extensions.nix pkgs/default.nix
git commit -m "feat: package pi claude-marketplace extensions"
```

---

### Task 4: Home Manager module

**Files:**
- Create: `home/pi.nix`
- Modify: `flake.nix`

- [ ] **Step 1: Create home/pi.nix**

```nix
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
```

- [ ] **Step 2: Add to baseHomeModules in flake.nix**

In `flake.nix`, in the `baseHomeModules` list, add after `./home/claude.nix`:

```nix
      ./home/pi.nix
```

- [ ] **Step 3: Evaluate the home configuration**

Run:
```bash
nix eval .#homeConfigurations.lars.activationPackage --apply builtins.attrNames >/dev/null && echo EVAL_OK
```
Expected: `EVAL_OK`.

- [ ] **Step 4: Format and check**

Run:
```bash
just fmt
nix flake check
```
Expected: both succeed.

- [ ] **Step 5: Commit**

```bash
git add home/pi.nix flake.nix
git commit -m "feat: install pi coding agent via Home Manager"
```

---

### Task 5: Final verification

- [ ] **Step 1: Run verify gates**

```bash
nix fmt
nix flake check
nix build .#pi-coding-agent
./result/bin/pi --version
```
Expected: all succeed; version prints `0.84.2`.

- [ ] **Step 2: Dry-build the user configuration**

```bash
nix build .#homeConfigurations.lars.activationPackage
```
Expected: succeeds. (Do not activate — the user applies with `just user lars`.)

- [ ] **Step 3: Report**

Summarize to the user: what was installed, the runtime steps remaining (`pi` → `/login` → Claude enterprise org → `/claude:plugin bootstrap`), and the `pi update --extensions` caveat.
