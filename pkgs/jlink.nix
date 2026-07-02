# jLink: Jabra headset/dongle manager for Linux (https://github.com/Watchdog0x/jLink)
# Upstream only ships a prebuilt binary plus an install script that embeds the
# proprietary libjabra.so as a hex blob, so we repackage both here.
{pkgs}: let
  version = "0.1.1";
  # Pinned commit of the install script that embeds libjabra.so (hex encoded).
  installScript = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Watchdog0x/jLink/64bba7e3a3e626aaf6e8bc7928936a6593499197/install.sh";
    hash = "sha256-vWiErLFTslQF44eAiubY0uYPaoQEfCPPxnLShfQQoBg=";
  };
in
  pkgs.stdenv.mkDerivation {
    pname = "jlink-jabra";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/Watchdog0x/jLink/releases/download/${version}/jLink";
      hash = "sha256-BeHuYQ3gIH92ZUqsiJ2qcY3cTRV4bo8/l+GLK7M0lgY=";
    };

    dontUnpack = true;

    nativeBuildInputs = with pkgs; [autoPatchelfHook xxd];

    buildInputs = with pkgs; [
      stdenv.cc.cc.lib # libstdc++ for libjabra
      alsa-lib
      curl
      udev
    ];

    installPhase = ''
      runHook preInstall

      # Extract the embedded proprietary libjabra.so from the install script
      mkdir -p $out/lib
      sed -n 's/^libjabraSo="\(.*\)"$/\1/p' ${installScript} \
        | sed 's/0x//g' | xxd -r -p > $out/lib/libjabra.so
      echo "5092ca68e1b6081de35ccd001f2d974f  $out/lib/libjabra.so" | md5sum -c -
      ln -s libjabra.so $out/lib/libjabra.so.1

      install -Dm755 $src $out/bin/jlink

      # Device access for Jabra (vendor id 0b0e), same rule as upstream installer
      mkdir -p $out/lib/udev/rules.d
      echo 'ATTRS{idVendor}=="0b0e", MODE="0660", GROUP="users"' \
        > $out/lib/udev/rules.d/99-jabra.rules

      runHook postInstall
    '';

    meta = {
      description = "Jabra Direct for Linux: manage Jabra headsets and dongles";
      homepage = "https://github.com/Watchdog0x/jLink";
      # CLI is Apache-2.0 but bundles the proprietary libjabra SDK
      license = pkgs.lib.licenses.unfree;
      platforms = ["x86_64-linux"];
      mainProgram = "jlink";
    };
  }
