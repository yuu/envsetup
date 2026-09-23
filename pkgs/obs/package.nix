{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "obs";
  version = "32.2.2";

  src = fetchurl {
    url = "https://cdn-fastly.obsproject.com/downloads/obs-studio-${finalAttrs.version}-macos-apple.dmg";
    hash = "sha256-kg1vJnA9LfbkCFvTwcvtMEiDJQhBNsem6eNwIfvWqvc=";
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = "OBS.app";

  # 署名済みの .app 。fixupPhase に触らせない
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/OBS.app"
    cp -R . "$out/Applications/OBS.app"

    runHook postInstall
  '';

  meta = {
    description = "Software for live streaming and screen recording";
    homepage = "https://obsproject.com/";
    license = lib.licenses.gpl2Plus;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
