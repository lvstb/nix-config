# Builds Pi extension packages from their npm tarballs.
# Extensions are TypeScript loaded by pi's bundled jiti, so no compile step;
# but each package's runtime dependencies must be present in node_modules
# next to its sources. Lockfiles are pinned in pkgs/pi-extensions/<name>/.
{pkgs}: let
  mkPiExtension = {
    name,
    version,
    hash,
    npmDepsHash,
    # Overrides for exact-pinned dependencies in the published package.json
    # (e.g. to pick up security fixes); must match the pinned lockfile.
    depOverrides ? {},
    ...
  } @ args:
    pkgs.buildNpmPackage ({
        pname = name;
        inherit version;

        src = pkgs.fetchurl {
          url = "https://registry.npmjs.org/${name}/-/${name}-${version}.tgz";
          inherit hash;
        };

        # Tarballs ship no lockfile; use the repo-pinned one.
        # devDependencies are intentionally not in the pinned lockfile (pi loads
        # the TS sources with its own jiti, nothing is compiled here), so strip
        # them: `npm ci` refuses to run when package.json and the lockfile are
        # out of sync.
        postPatch = ''
          chmod u+w .
          cp ${./pi-extensions/${name}/package-lock.json} package-lock.json
          ${pkgs.jq}/bin/jq --argjson overrides '${builtins.toJSON depOverrides}' \
            'del(.devDependencies) | .dependencies += $overrides' package.json > package.json.tmp
          mv package.json.tmp package.json
        '';

        inherit npmDepsHash;

        dontBuild = true;

        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp -r . $out/
          runHook postInstall
        '';
      }
      // (removeAttrs args ["name" "version" "hash" "npmDepsHash" "depOverrides"]));
in {
  pi-claude-marketplace = mkPiExtension {
    name = "pi-claude-marketplace";
    version = "0.14.0";
    hash = "sha256-fRgINRoaWf77Er3Yjka7SG9fgRUAjxkMJup0Ny88AxM=";
    npmDepsHash = "sha256-bT5fuMEHkLiAjpMfv514+gQWcW9C4o7JY3kW87JmSRM=";
    # pi-coding-agent is a required (unresolvable, intentionally absent) peer
    # dep provided by the pi runtime at load time; npm ci must not fetch it
    npmFlags = ["--legacy-peer-deps"];
  };

  pi-subagents = mkPiExtension {
    name = "pi-subagents";
    version = "0.49.0";
    hash = "sha256-Yl8uNzdGupibcf1VlZmFJbjDXiVPtwYsiZJqyb65xOU=";
    npmDepsHash = "sha256-Wgx2joCBIvb8U54zeb5PizI0jZBYrIyr70OZ3Oalub4=";
    # Optional pi peer deps are not in the pinned lockfile, so npm ci would
    # try to fetch them
    npmFlags = ["--omit=peer" "--ignore-scripts"];
  };

  pi-mcp-adapter = mkPiExtension {
    name = "pi-mcp-adapter";
    version = "2.25.0";
    hash = "sha256-JLgOGPUsgT9466B4hCX5EFvD9d0rkwCwdkE7JQtobgQ=";
    npmDepsHash = "sha256-H7anYss/5g2aiFhcBwULLpW9ncCs+ItV+YbGO0V6OFc=";
    # Upstream pins these exactly; 2.0.0 has high-severity advisories fixed in 2.3.0
    # (client 2.3.0 requires core 2.3.0), and open 10.x is fixed in 11.x.
    depOverrides = {
      "@modelcontextprotocol/client" = "2.3.0";
      "@modelcontextprotocol/core" = "2.3.0";
      open = "^11.0.0";
    };
  };
}
