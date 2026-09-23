{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bambu-studio";
  version = "02.08.02.61";

  src = fetchurl {
    url = "https://github.com/bambulab/BambuStudio/releases/download/v${finalAttrs.version}/Bambu_Studio_mac-v${finalAttrs.version}-20260820225108.dmg";
    hash = "sha256-z2SKlYWPtjDhNTxJhwON9g1sqraT8YQR+5X7gJ8taSY=";
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = "BambuStudio.app";

  # 署名済みの .app 。fixupPhase に触らせない
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/BambuStudio.app"
    cp -R . "$out/Applications/BambuStudio.app"

    runHook postInstall
  '';

  meta = {
    description = "3D model slicing software for Bambu Lab printers";
    homepage = "https://bambulab.com/en/download/studio";
    license = lib.licenses.agpl3Only;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
