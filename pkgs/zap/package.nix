{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zap";
  version = "2.17.0";

  src = fetchurl {
    url = "https://github.com/zaproxy/zaproxy/releases/download/v${finalAttrs.version}/ZAP_${finalAttrs.version}_aarch64.dmg";
    hash = "sha256-OzxsixBaM8sqfXGOf5qkFBim2KrjiH2UpCUjte6scjs=";
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = "ZAP.app";

  # 署名済みの .app 。fixupPhase に触らせない
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/ZAP.app"
    cp -R . "$out/Applications/ZAP.app"

    runHook postInstall
  '';

  meta = {
    description = "Web app scanner";
    homepage = "https://www.zaproxy.org/";
    license = lib.licenses.asl20;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
