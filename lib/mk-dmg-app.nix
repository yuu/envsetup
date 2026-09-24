{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

{
  pname,
  version,
  url,
  hash,
  app,
  meta ? { },
}:

stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl { inherit url hash; };

  # supported HFS / APFS with dmg
  nativeBuildInputs = [ _7zz ];
  unpackPhase = ''
    runHook preUnpack
    7zz x -snld "$src"
    runHook postUnpack
  '';
  sourceRoot = app;

  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/${app}"
    cp -R . "$out/Applications/${app}"

    runHook postInstall
  '';

  meta = {
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  } // meta;
}
