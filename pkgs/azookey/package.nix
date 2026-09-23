{
  lib,
  stdenvNoCC,
  fetchurl,
  xar,
  cpio,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "azookey";
  version = "0.1.4";

  src = fetchurl {
    url = "https://github.com/azooKey/azooKey-Desktop/releases/download/v${finalAttrs.version}/azooKey-release-signed.pkg";
    hash = "sha256-04kxXJKMKNpzLE6yrejtDBnIlv3wb4NTrGF9ldzys5w=";
  };

  nativeBuildInputs = [
    xar
    cpio
  ];

  # .pkg (xar) の中の Payload (gzip の cpio) を展開する
  unpackPhase = ''
    runHook preUnpack
    xar -xf "$src"
    gunzip -c azooKey-tmp.pkg/Payload | cpio -i --quiet
    runHook postUnpack
  '';

  # 署名済みの .app 。fixupPhase に触らせない
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Library/Input Methods"
    cp -R azooKeyMac.app "$out/Library/Input Methods/"

    runHook postInstall
  '';

  meta = {
    description = "Japanese input method for macOS";
    homepage = "https://github.com/azooKey/azooKey-Desktop";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
