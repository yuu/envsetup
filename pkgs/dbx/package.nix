{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dbx";
  version = "0.6.20";

  src = fetchurl {
    url = "https://github.com/t8y2/dbx/releases/download/v${finalAttrs.version}/DBX_${finalAttrs.version}_arm64.dmg";
    hash = "sha256-5v5INXMaxkYmfbspsfqoi0Ie1bFDmgr+Xir7gfrN83k=";
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = "DBX.app";

  # 署名済みの .app 。fixupPhase に触らせない
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/DBX.app"
    cp -R . "$out/Applications/DBX.app"

    runHook postInstall
  '';

  meta = {
    description = "Database management tool";
    homepage = "https://dbxio.com/";
    license = lib.licenses.asl20;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
