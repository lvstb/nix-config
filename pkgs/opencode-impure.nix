{
  lib,
  stdenv,
  unzip,
  autoPatchelfHook,
  glibc,
}:

let
  platform = if stdenv.isDarwin then "darwin" else "linux";
  arch = if stdenv.isAarch64 then "arm64" else "x64";
  
  # This uses builtins.fetchurl with platform-specific hashes for pure evaluation
  src = builtins.fetchurl {
    url = "https://github.com/sst/opencode/releases/latest/download/opencode-${platform}-${arch}.zip";
    sha256 = if platform == "linux" then (
      if arch == "x64" then "1j3qggzz42wbffa5lcqhxccr5j2qdvfnznnax4wrf4vmw03r7sg0" else "0h1d68wglzqckij2djrnlma93xnjz1a5avqpsj7icgiya2a5ydss"
    ) else (
      if arch == "x64" then "146zr3x12dhn9wik9h5799agb50vlq7j8p87x8hlw90lx94minpd" else "0xvq8k377a7y4n3xgcfgnz9cnxs5gka5r33d0nr9mcdw6pdnqa09"
    );
  };
in

stdenv.mkDerivation rec {
  pname = "opencode";
  version = "latest";

  inherit src;

  nativeBuildInputs = [ unzip ] ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.isLinux [ glibc ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/bin
    cp opencode $out/bin/
    chmod +x $out/bin/opencode
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "AI coding agent, built for the terminal (always latest version)";
    homepage = "https://opencode.ai";
    license = licenses.mit;
    maintainers = [ ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "opencode";
  };
}