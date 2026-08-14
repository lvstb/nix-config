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
          ${pkgs.jq}/bin/jq 'del(.devDependencies)' package.json > package.json.tmp
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
      // (removeAttrs args ["name" "version" "hash" "npmDepsHash"]));
in {
  pi-claude-marketplace = mkPiExtension {
    name = "pi-claude-marketplace";
    version = "0.14.0";
    hash = "sha256-fRgINRoaWf77Er3Yjka7SG9fgRUAjxkMJup0Ny88AxM=";
    npmDepsHash = "sha256-eDNKNkjLp8yNTIYtsh8cDse9yhacpTihd6uV+LfP3Go=";
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
    npmDepsHash = "sha256-Vq10+qfZ9tAqpl1Ghmn28gc9l5lLstK1dZia8t/nqQI=";
  };
}
