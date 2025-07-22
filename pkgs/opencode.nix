{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  glibc,
}:

let
  platform = if stdenv.isDarwin then "darwin" else "linux";
  arch = if stdenv.isAarch64 then "arm64" else "x64";
in

stdenv.mkDerivation rec {
  pname = "opencode";
  version = "latest";

  src = fetchzip {
    url = "https://github.com/sst/opencode/releases/latest/download/opencode-${platform}-${arch}.zip";
    sha256 = "sha256-aOJJJOKL+/pV8KHMzKXJOUqfn5s6xUL9Uu3A9+yA=";
    stripRoot = false;
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.isLinux [ glibc ];



  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/bin
    cp opencode $out/bin/
    chmod +x $out/bin/opencode
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "AI coding agent, built for the terminal";
    homepage = "https://opencode.ai";
    license = licenses.mit;
    maintainers = [ ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "opencode";
  };
}