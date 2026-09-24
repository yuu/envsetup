{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-drive-cli";
  version = "0.8.0";

  src = fetchurl {
    url = "https://proton.me/download/drive/cli/${finalAttrs.version}/darwin-arm64/proton-drive";
    hash = "sha256-3I/BTenvB/zvKP4gQFG7ZynEnPV5FwyM4a1mmiZ2lxE=";
  };

  dontUnpack = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/proton-drive
    runHook postInstall
  '';

  meta = {
    description = "Proton Drive CLI";
    homepage = "https://proton.me/download/drive/cli/index.html";
    license = lib.licenses.unfree;
    mainProgram = "proton-drive";
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
