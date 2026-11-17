{pkgs}: let
  inherit (pkgs) lib;
in
  pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "codex-app";
    version = "26.1106.51428";

    # The official OpenAI desktop app (ChatGPT + Codex) for Linux.
    # Only an unversioned "latest" URL is published, so the hash pins the build.
    src = pkgs.fetchurl {
      url = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/latest/chatgpt_amd64.deb";
      sha256 = "sha256-g1anghkwsTW3QTR/rMvEPhaStEJMPqtxCpr1bAvrsTU=";
    };

    nativeBuildInputs = with pkgs; [
      dpkg
      autoPatchelfHook
      makeWrapper
      wrapGAppsHook3
      copyDesktopItems
    ];

    buildInputs = with pkgs; [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      dbus
      expat
      gdk-pixbuf
      glib
      gtk3
      libdrm
      libgbm
      libnotify
      libsecret
      libusb1
      libxkbcommon
      nspr
      nss
      openssl
      pango
      stdenv.cc.cc.lib
      systemd
      tpm2-tss
      libx11
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      libxcb
    ];

    runtimeDependencies = with pkgs; [
      libglvnd
      libgbm
      libpulseaudio
      systemd
      vulkan-loader
      xdg-utils
    ];

    # Qt shims are optional (only used with -platform qt) and musl prebuilds
    # of native node modules are unused on a glibc system.
    autoPatchelfIgnoreMissingDeps = [
      "libQt5Core.so.5"
      "libQt5Gui.so.5"
      "libQt5Widgets.so.5"
      "libQt6Core.so.6"
      "libQt6Gui.so.6"
      "libQt6Widgets.so.6"
      "libc.musl-x86_64.so.1"
    ];

    # Electron bundles prebuilt binaries; skip the usual fixups.
    dontConfigure = true;
    dontBuild = true;
    dontWrapGApps = true;

    unpackPhase = ''
      runHook preUnpack
      dpkg-deb -x $src .
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib $out/bin $out/share/pixmaps
      cp -r usr/lib/chatgpt $out/lib/codex-app
      cp usr/share/pixmaps/chatgpt.png $out/share/pixmaps/codex-app.png

      rm -f $out/lib/codex-app/codex-launcher

      makeWrapper $out/lib/codex-app/ChatGPT $out/bin/codex-app \
        "''${gappsWrapperArgs[@]}" \
        --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils pkgs.git]} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

      ln -s $out/bin/codex-app $out/bin/chatgpt

      runHook postInstall
    '';

    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "codex-app";
        desktopName = "ChatGPT (Codex)";
        genericName = "AI assistant";
        comment = "ChatGPT and Codex desktop app by OpenAI";
        exec = "codex-app %U";
        icon = "codex-app";
        startupNotify = true;
        categories = ["Utility" "Development"];
        mimeTypes = ["x-scheme-handler/codex"];
      })
    ];

    meta = {
      description = "Official OpenAI ChatGPT and Codex desktop app";
      homepage = "https://developers.openai.com/codex/app";
      license = lib.licenses.unfree;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
      platforms = ["x86_64-linux"];
      mainProgram = "codex-app";
    };
  })
