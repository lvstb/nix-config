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

    # The tarball ships npm-shrinkwrap.json without integrity fields, which
    # fetchNpmDeps can't parse (it also prefers shrinkwrap over lockfile).
    # Use a regenerated package-lock.json (npm install --package-lock-only)
    # with full integrity entries instead.
    postPatch = ''
      chmod u+w .
      cp ${./pi-coding-agent/package-lock.json} package-lock.json
      rm -f npm-shrinkwrap.json
    '';

    npmDepsHash = "sha256-cKitVE175ZKdeY+kxT1m7TROrLNSNLAIZRYFlufw/jM=";

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
