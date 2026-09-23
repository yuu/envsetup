{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bettertouchtool";
  version = "6.845";

  src = fetchurl {
    url = "https://folivora.ai/releases/btt${finalAttrs.version}-2026092108.zip";
    hash = "sha256-o8SNr/QaxPl2Bs/8PP1/s9IkNhCZQZ8oqMa1oPpwdQM=";
  };

  nativeBuildInputs = [ unzip ];
  sourceRoot = "BetterTouchTool.app";

  # 署名済みの .app 。fixupPhase に触らせない
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/BetterTouchTool.app"
    cp -R . "$out/Applications/BetterTouchTool.app"

    runHook postInstall
  '';

  meta = {
    description = "Tool to customise input devices and automate computer systems";
    homepage = "https://folivora.ai/";
    license = lib.licenses.unfree;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
