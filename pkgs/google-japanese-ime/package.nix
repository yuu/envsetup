{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  xar,
  cpio,
}:

stdenvNoCC.mkDerivation {
  pname = "google-japanese-ime";
  version = "3.33.6130";

  src = fetchurl {
    # ponytail: 配布 URL が latest 固定。新版が出ると hash 不一致で落ちるので、そのときは
    # `nix store prefetch-file https://dl.google.com/japanese-ime/latest/GoogleJapaneseInput.dmg` で hash を更新する
    url = "https://dl.google.com/japanese-ime/latest/GoogleJapaneseInput.dmg";
    hash = "sha256-749fuw3zrpNGDt0/taaFtwnENd0vpwsKphhHMmbDSYw=";
  };

  nativeBuildInputs = [
    undmg
    xar
    cpio
  ];

  # dmg → 外側の pkg (xar) → 本体 pkg の Payload (gzip cpio)
  # GoogleUpdater.pkg と postinstall の Keystone 登録は使わない
  unpackPhase = ''
    runHook preUnpack
    undmg "$src"
    mkdir outer root
    (cd outer && xar -xf ../GoogleJapaneseInput.pkg)
    (cd root && gunzip -c ../outer/GoogleJapaneseInput.pkg/Payload | cpio -i --quiet)
    runHook postUnpack
  '';
  sourceRoot = "root";

  # 署名済みの .app 。fixupPhase に触らせない
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    # Applications/ 配下の ConfigDialog.app 等は IME 本体内への絶対パスのシンボリックリンクなので入れない
    mkdir -p "$out/Library"
    cp -R "Library/Input Methods" "$out/Library/"

    runHook postInstall
  '';

  meta = {
    description = "Japanese input method by Google";
    homepage = "https://www.google.co.jp/ime/";
    license = lib.licenses.unfree;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
