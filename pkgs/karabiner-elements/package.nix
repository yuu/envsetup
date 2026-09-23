{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  xar,
  cpio,
}:

# nixpkgs の karabiner-elements はヘルパー内の plist を書き換えて署名が壊れているので、
# 公式 pkg を無加工で展開する。配置は darwin.nix の activation で公式の場所へコピーする。
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "karabiner-elements";
  version = "15.7.0";

  src = fetchurl {
    url = "https://github.com/pqrs-org/Karabiner-Elements/releases/download/v${finalAttrs.version}/Karabiner-Elements-${finalAttrs.version}.dmg";
    hash = "sha256-Uy0k4xxkr33j92jxEhD/6DF0hhkdf8acU7lr3hTaFa4=";
  };

  nativeBuildInputs = [
    undmg
    xar
    cpio
  ];

  # dmg → pkg (xar) → 本体とドライバの Payload (gzip cpio)。どちらも install-location="/"
  unpackPhase = ''
    runHook preUnpack
    undmg "$src"
    mkdir outer root
    (cd outer && xar -xf ../Karabiner-Elements.pkg)
    for p in Installer Karabiner-DriverKit-VirtualHIDDevice; do
      (cd root && gunzip -c "../outer/$p.pkg/Payload" | cpio -i --quiet)
    done
    # Payload 内の AppleDouble (._*) は macOS のインストーラなら拡張属性に戻るが、
    # cpio では通常ファイルになり署名検証を壊すので消す
    find root -name '._*' -delete
    runHook postUnpack
  '';

  # 署名済みの .app 。fixupPhase に触らせない
  dontFixup = true;

  # $out/Applications に置くと /Applications/Nix Apps にも出てしまうので root/ 以下に置く
  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -R root "$out/root"
    # 公式 postinstall のうち $out 内で完結するもの
    cp "$out/root/Library/Application Support/org.pqrs/Karabiner-Elements/package-version" \
       "$out/root/Library/Application Support/org.pqrs/Karabiner-Elements/version"
    runHook postInstall
  '';

  meta = {
    description = "Keyboard customizer for macOS (official pkg layout, unpatched)";
    homepage = "https://karabiner-elements.pqrs.org/";
    license = lib.licenses.unlicense;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
