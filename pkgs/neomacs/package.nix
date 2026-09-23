{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "neomacs";
  version = "0.0.19";

  src = fetchurl {
    url = "https://github.com/eval-exec/neomacs/releases/download/v${finalAttrs.version}/neomacs-${finalAttrs.version}-aarch64-apple-darwin.zip";
    hash = "sha256-X1rcCit6SkjlauhKTWb8vTqyyWZfXQkzhdiVrbiBNds=";
  };

  sourceRoot = "neomacs-${finalAttrs.version}-aarch64-apple-darwin";

  nativeBuildInputs = [ unzip ];

  # ad-hoc 署名済みの .app 。fixupPhase に Mach-O を触らせて署名を壊さない
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    cp -R neomacs.app "$out/Applications/"
    ln -s "$out/Applications/neomacs.app/Contents/MacOS/neomacs"       "$out/bin/neomacs"
    ln -s "$out/Applications/neomacs.app/Contents/MacOS/neomacsclient" "$out/bin/neomacsclient"

    runHook postInstall
  '';

  meta = {
    description = "GPU powered Emacs written in Rust with a modern display engine";
    homepage = "https://neomacs.org";
    license = lib.licenses.gpl3Plus;
    platforms = [ "aarch64-darwin" ];
    mainProgram = "neomacs";
  };
})
