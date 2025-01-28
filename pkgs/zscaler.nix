{ stdenv, dpkg, glibc, gcc-unwrapped, autoPatchelfHook }:
let

  version = "3.7.0.142-0";

  src = .zscaler/zscaler-client_3.7.0.142-0_amd64.deb;

in stdenv.mkDerivation {
  name = "zscaler-${version}";

  system = "x86_64-linux";

  inherit src;

  # Required for compilation
  nativeBuildInputs = [
    autoPatchelfHook # Automatically setup the loader, and do the magic
    dpkg
  ];

  # Required at running time
  buildInputs = [
    glibc
    gcc-unwrapped
  ];

  unpackPhase = "true";

  # Extract and copy executable in $out/bin
  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    cp -av $out/opt/zscaler/* $out
    rm -rf $out/opt
  '';

  meta = with stdenv.lib; {
    description = "zscaler";
    homepage = "https://www.zscaler.com/";
    license = licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}

