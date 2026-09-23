{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tor-browser";
  version = "15.0.23";

  src = fetchurl {
    url = "https://www.torproject.org/dist/torbrowser/${finalAttrs.version}/tor-browser-macos-${finalAttrs.version}.dmg";
    hash = "sha256-KrIZSP64Mnu8ztIXT9f0uUook1AGDE67wc2W0owzPbk=";
  };

  # APFS の dmg なので undmg では開けない
  nativeBuildInputs = [ _7zz ];
  unpackPhase = ''
    runHook preUnpack
    7zz x -snld "$src"
    runHook postUnpack
  '';
  sourceRoot = "Tor Browser/Tor Browser.app";

  # 署名済みの .app 。fixupPhase に触らせない
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Tor Browser.app"
    cp -R . "$out/Applications/Tor Browser.app"

    runHook postInstall
  '';

  meta = {
    description = "Web browser focusing on security";
    homepage = "https://www.torproject.org/";
    license = lib.licenses.mpl20;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
