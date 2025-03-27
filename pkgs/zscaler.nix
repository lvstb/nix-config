{
  stdenv,
  dpkg,
  glibc,
  gcc-unwrapped,
  autoPatchelfHook,
}: let
  version = "3.7.0.142-0";
  src = ./zscaler-client_3.7.0.142-0_amd64.deb; # Assuming .deb is in the same directory
in
  stdenv.mkDerivation {
    name = "zscaler-${version}";
    system = "x86_64-linux";
    inherit src;

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
    ];

    buildInputs = [
      glibc
      gcc-unwrapped # May or may not be strictly necessary at runtime
    ];

    installPhase = ''
      mkdir -p $out
      dpkg -x $src $out
    '';

    meta = with stdenv.lib; {
      description = "Zscaler client";
      homepage = "https://www.zscaler.com/";
      license = licenses.unfree; # Update with the correct license if known
      maintainers = with stdenv.lib.maintainers; [yourUsername]; # Add your username
      platforms = ["x86_64-linux"];
    };
  }
