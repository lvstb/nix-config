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
  
  # This uses builtins.fetchurl which doesn't require a hash but needs --impure
  src = builtins.fetchurl "https://github.com/sst/opencode/releases/latest/download/opencode-${platform}-${arch}.zip";
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