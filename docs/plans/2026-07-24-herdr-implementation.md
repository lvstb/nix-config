# Herdr Integration Implementation Plan

**Goal:** Install Herdr persistently in both shared Home Manager profiles.
**Architecture:** Add the Herdr flake as an input following this repository's `nixpkgs`, apply Herdr's default overlay to the shared package set, and add `pkgs.herdr` to the shared Home Manager package list. No local package wrapper or redundant flake package output is needed.
**Tech Stack:** Nix flakes, nixpkgs overlays, Home Manager.

---

### Task 1: Wire the Herdr flake input and overlay

**Files:**
- Modify: `flake.nix:4-83` for the input declaration and `flake.nix:98-109` for the overlay list.

**Step 1: Add the input**

Declare `herdr.url = "github:ogulcancelik/herdr"` and set `inputs.nixpkgs.follows = "nixpkgs"`.

**Step 2: Apply the package overlay**

Add `inputs.herdr.overlays.default` to the existing `overlays` list so the shared `pkgs` import exposes `pkgs.herdr`.

**Step 3: Evaluate the package attribute**

Run:

```bash
nix eval --raw '.#homeConfigurations.lars.pkgs.herdr.pname'
```

Expected: `herdr`.

**Step 4: Commit**

```bash
git add flake.nix flake.lock
git commit -m "feat: add Herdr flake input"
```

### Task 2: Install Herdr through Home Manager

**Files:**
- Modify: `home/apps.nix:582-607`.

**Step 1: Add the package**

Add `herdr` to the existing application/development package list, using the overlay-provided `pkgs.herdr` value through the surrounding `with pkgs` expression.

**Step 2: Evaluate both Home Manager profiles**

Run:

```bash
nix eval --raw '.#homeConfigurations.lars.config.home.packages' >/dev/null
nix eval --raw '.#homeConfigurations.lars-hyprland.config.home.packages' >/dev/null
```

Expected: both evaluations succeed.

**Step 3: Commit**

```bash
git add home/apps.nix
git commit -m "feat: install Herdr in Home Manager"
```

### Task 3: Format and verify the complete flake

**Files:**
- Verify: `flake.nix`, `home/apps.nix`, `flake.lock`.

**Step 1: Format Nix files**

Run `nix fmt` from the repository root.

Expected: formatting completes without errors.

**Step 2: Check the flake**

Run `nix flake check` from the repository root.

Expected: all checks pass.

**Step 3: Inspect the scoped diff**

Run `git diff HEAD~2 -- flake.nix home/apps.nix flake.lock` and verify only the Herdr input, overlay, package entry, and generated lock data are present. Confirm no `packages.x86_64-linux.herdr` output was added.

**Step 4: Commit formatting and verification changes if needed**

```bash
git add flake.nix home/apps.nix flake.lock
git commit -m "chore: format Herdr integration"
```
